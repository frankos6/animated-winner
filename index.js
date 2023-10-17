import {Sequelize, DataTypes} from "sequelize";
import restify from "restify";
import errors from "restify-errors";

const app = restify.createServer();
app.pre(restify.pre.sanitizePath())
app.use(restify.plugins.bodyParser({rejectUnknown: true}))
app.use(restify.plugins.throttle({
    burst: 10,
    rate: 10,
    ip: true,
    overrides: {
        '127.0.0.1': {
            rate: 0
        }
    }
}))
app.use(restify.plugins.authorizationParser())
const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: 'database.db'
})

try {
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');
} catch (error) {
    console.error('Unable to connect to the database:', error);
}

const User = sequelize.define('User', {
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    isAdmin: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false
    },
    isDevice: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false
    }
})

const Device = sequelize.define('Device',{
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    location: DataTypes.STRING,
    isConnected: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
    },
    lastSeen: DataTypes.DATE,
},{
    tableName: 'IoTDevices',
})

Device.belongsTo(User);
User.hasOne(Device,{
    foreignKey: {
        allowNull: false
    }
});

const DeviceData = sequelize.define('DeviceData',{
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    payload: DataTypes.JSON
},{
    timestamps: true,
    updatedAt: false,
    createdAt: 'timestamp'
})

Device.hasMany(DeviceData)
DeviceData.belongsTo(Device)

const DeviceConfiguration = sequelize.define('DeviceConfiguration',{
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    deviceId: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    params: DataTypes.JSON
})

Device.hasMany(DeviceConfiguration,{
    foreignKey: 'deviceId'
})
DeviceData.belongsTo(Device)

const Alert = sequelize.define('Alert',{
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    message: DataTypes.STRING
},{
    timestamps: true,
    updatedAt: false,
    createdAt: 'timestamp'
})

Device.hasMany(Alert)
Alert.belongsTo(Device)

const APILog = sequelize.define('APILog',{
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    endpoint: DataTypes.STRING,
    responseStatus: DataTypes.INTEGER
},{
    timestamps: true,
    updatedAt: false,
    createdAt: 'timestamp',
    tableName: 'APIRequestLog'
})


await sequelize.sync()

app.on('after',async (req,res,route)=>{
    console.log(`endpoint ${route ? route.path : req.getPath()} - response code ${res.statusCode} ${res.body || ''}`)
    await APILog.create({endpoint: route ? route.path : req.getPath(), responseStatus: res.statusCode})
})
// endpoints without auth
app.get('/',async (req,res)=>{
    res.send('hello world!')
});

app.post('/device/register', async (req, res)=>{
    const devices = await Device.count()
    const {username, password} = await sequelize.transaction(async (t) => {
        const newUser = await User.create({username: `device${devices+1}`, password: Math.random().toString(36).substring(2,10), isDevice: true}, {transaction: t})
        await Device.create({name: newUser.username, UserId: newUser.id}, {transaction: t})
        return newUser
    })
    return res.send(201,{username, password})
})

app.post('/user/register', async (req, res)=>{
    const {username, password} = req.body
    if (!username || !password) {
        throw new errors.BadRequestError('You need to provide a username and password')
    }
    const users = await User.findAll({
        where: {
            username
        }
    })
    if (users.length !== 0) {
        throw new errors.ConflictError('An user with this username already exists')
    }
    if (username.toLowerCase().startsWith('device')) {
        throw new errors.ConflictError('This username is reserved for devices')
    }
    await User.create({username, password})
    return res.send(201,'User created')
})

// auth handler
const authFn = async (req, res)=>{
    if (!req.username)
        throw new errors.InvalidCredentialsError('No credentials provided')
    const users = await User.findAll({
        where: {
            username: req.username
        }
    })
    if (users.length !== 1)
        throw new errors.InvalidCredentialsError()
    if (!req.authorization.basic)
        throw new errors.InvalidHeaderError('Invalid authorization scheme')
    if (users[0].password !== req.authorization.basic.password)
        throw new errors.InvalidCredentialsError('Invalid password')

    req.user = users[0];
}

// device id param handler
const deviceFn = async (req, res) => {
    if (!req.params.id || req.params.id === '') throw new errors.MissingParameterError('You need to provide a device id')
    const device = await Device.findOne({ where: { id: req.params.id } })
    if (!device) throw new errors.NotFoundError(`A device with id ${req.params.id} does not exist`)
    req.device = device
}

// permission handler
const adminFn = async (req, res) => {
    if (!req.user.isAdmin) throw new errors.UnauthorizedError('Only an admin can perform this action')
}

// handler for user-only routes
const isUserFn = async (req, res) => {
    if (req.user.isDevice) throw new errors.UnauthorizedError('Devices cannot access this endpoint')
}

// handler for device-only routes
const isDeviceFn = async (req, res) => {
    if (!req.user.isDevice) throw new errors.UnauthorizedError('Only devices can access this endpoint')
    req.device = await Device.findOne({where: {UserId: req.user.id}})
}

// endpoints with auth

app.get('/auth',[authFn, async (req, res) => {
    return res.send(`Your credentials are correct!\nYou are logged in as ${req.username}.`)
}])

app.get('/device/list',[authFn, isUserFn, async (req,res) => {
    const devices = await Device.findAll();
    return res.send(devices.map(d=>d.toJSON()))
}])

app.get('/device/:id',[authFn, isUserFn, deviceFn,
    async (req, res) => res.send(req.device.toJSON())
])

app.del('/device/:id',[authFn, isUserFn, deviceFn, adminFn, async (req, res) => {
    await sequelize.transaction(async (transaction) => {
        await DeviceConfiguration.destroy({where: {deviceId: req.device.id}, transaction})
        await Alert.destroy({where: {deviceId: req.device.id}, transaction})
        await DeviceData.destroy({where: {deviceId: req.device.id}, transaction})
        await Device.destroy({where: {id: req.device.id}, transaction})
        await User.destroy({where: {id: req.device.UserId}, transaction})
    })
    res.send(204)
}])

app.get('/device/:id/alerts',[authFn, isUserFn, deviceFn,
    async (req, res) => res.send((await Alert.findAll({where: {deviceId: req.params.id }})).map(e=>e.toJSON()))
])

app.get('/device/:id/data',[authFn, isUserFn, deviceFn,
    async (req, res) => res.send((await DeviceData.findAll({where: {deviceId: req.params.id}, limit: req.query.limit || 10})).map(e=>e.toJSON()))
])

app.get('/device/:id/config',[authFn, isUserFn, deviceFn, adminFn,
    async (req, res)=> {
        const config = await DeviceConfiguration.findOne({where: {deviceId: req.params.id}})
        if (!config) res.send({})
        else res.send(config.toJSON())
    }
])

app.put('/device/:id/config',[authFn, isUserFn, deviceFn, adminFn,
    async (req, res)=>{
    if (await DeviceConfiguration.findOne({where: {deviceId: req.params.id}})) {
        await DeviceConfiguration.update({params: req.body},{
            where: {
                deviceId: req.params.id
            }
        })
        res.send(200)
    } else {
        await DeviceConfiguration.create({deviceId: req.params.id, params: req.body})
        res.send(201)
    }
}])

app.get('/alerts', [authFn, isUserFn,
    async (req, res)=> res.send((await Alert.findAll({limit: req.query.limit || 10})).map(e=>e.toJSON()))
])

app.listen(245,()=>console.log(`listening on port 245`))