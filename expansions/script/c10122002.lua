--空想星界 幽暗密林
local m=10122002
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.ToHandActivateEffect(c,m)
	local e3=rsef.QO(c,nil,{m,0},1,"tk,sp","tg",LOCATION_FZONE,nil,nil,cm.tg,rsul.TokenOp(cm.op,nil,1),rsul.hint)   
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and rsul.SpecialOrPlaceBool(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op(c,e)
	rsul.basetkop(c,e)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	   e:SetLabelObject(tc)
	   c[2]:SetCardTarget(tc)
	   c[2]:CreateRelation(tc,RESET_EVENT+0x5020000)
	   tc:CreateRelation(c[2],RESET_EVENT+0x5fe0000)
	   rsef.SV_IMMUNE_EFFECT(c,cm.val,nil,rsreset.est,nil,{m,4})
	end
end
function cm.val(e,re)
	local tc,c=e:GetLabelObject(),e:GetHandler()
	return re:GetOwner()==tc and tc:IsRelateToCard(c) and c:IsRelateToCard(tc)
end
