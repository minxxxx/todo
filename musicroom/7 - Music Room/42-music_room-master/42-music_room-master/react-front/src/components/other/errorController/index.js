import { message } from 'antd'

class Error {
    static display_error = (resp) =>{
        console.log(resp.response);
        if (!resp.response)
            message.error("error on remote");
        else if (resp.response.data.error)
            message.error(resp.response.data.error)
        else if (resp.response.status === 400)
            message.error("Token missing")
        else if (resp.response.status === 401)
            message.error("Token invalid")
        else
            message.error("Serveur Crash")
    }
}

export default Error;