
import * as functions from "firebase-functions";
import * as corsModule from "cors";
import * as express from "express";
import * as axios from "axios";
const app = express();
app.use(corsModule({origin: true}));
app.get("/:id", (req, res) => {
  const config = {
    method: "get",
    maxBodyLength: Infinity,
    url: `https://query1.finance.yahoo.com/v11/finance/quoteSummary/${req.params.id}.sa?lang=pt-br&modules=price,assetProfile`,
    headers: {
      "content-type": "application/json",
    },
  };
  axios.default.request(config)
    .then((response) => {
      return res.status(200).send(response.data);
    })
    .catch((error) => {
      return res.status(500).send(error);
    });
});
export const getPrices = functions.https.onRequest(app);
