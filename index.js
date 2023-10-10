import express from "express";
import {Sequelize, DataTypes} from "sequelize";

const app = express();
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
    isConnected: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
    },
    lastSeen: DataTypes.DATE
},{
    tableName: 'IoTDevices'
})

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
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    isAdmin: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false
    }
})

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
        console.log(`endpoint ${req.path} - response code ${res.statusCode} ${res.body | ''}`)
        await APILog.create({endpoint:req.path, responseStatus:res.statusCode})
    })
    next()
})

app.get('/',(req,res)=>{
    res.send('hello world!')
});

app.listen(245,()=>console.log(`listening on port 245`))