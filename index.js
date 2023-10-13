import express from "express";
import {Sequelize, DataTypes} from "sequelize";

const app = express();
app.use(express.json())
const sequelize = new Sequelize({
    dialect:'sqlite',
    storage:'database.db'
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


await sequelize.sync({alter: true})

app.use((req, res, next) => {
    res.on('finish', async () => {
        console.log(`endpoint ${req.path} - response code ${res.statusCode} ${res.body || ''}`)
        await APILog.create({endpoint:req.path, responseStatus:res.statusCode})
    })
    next()
})
// endpoints without auth
app.get('/',(req,res)=>{
    res.send('hello world!')
});

app.post('/device/register', async (req, res)=>{
    const devices = await Device.count()
    const newUser = await User.create({username: `device${devices}`, password: Math.random().toString(36).substring(2,10), isDevice: true})
    const newDevice = await Device.create({name: newUser.username, UserId: newUser.id})
    return res.status(201).send({username: newUser.username, password: newUser.password})
})

app.post('/user/register', async (req, res)=>{
    const {username, password} = req.body
    if (!username || !password) {
        res.status(400).send('You need to provide a username and password')
        return
    }
    const users = await User.findAll({
        where: {
            username
        }
    })
    if (users.length !== 0) {
        res.status(400).send('An user with this username already exists')
        return
    }
    const newUser = await User.create({username, password})
    return res.status(201).send('User created')
})

// endpoints with auth

app.use(async (req, res, next)=>{
    if (!req.headers.authorization) {
        res.status(401).send("No credentials provided")
        return
    }
    const token = req.headers.authorization.split(' ')[1]
    if (!token || token === '') {
        res.status(401).send("No credentials provided")
        return
    }
    const [username, password] = atob(token).split(':');
    const users = await User.findAll({
        where: {
            username
        }
    })
    if (users.length !== 1) {
        res.status(401).send("Invalid credentials")
        return
    }
    if (users[0].password !== password) {
        res.status(401).send("Invalid password")
        return
    }
    req.user = users[0];
    next()
})

// endpoints with auth

app.get('/auth',(req, res)=>{
    return res.status(200).send(`Your credentials are correct!\nYou are logged in as ${req.user.username}.`)
})


// error handler
app.use((err, req, res, next)=>{
    console.log(err.stack)
    res.status(500).send(err.message)
})
app.listen(245,()=>console.log(`listening on port 245`))