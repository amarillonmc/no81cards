--空想星界 幽暗密林
local m=10122002
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	rsef.ACT(c)
	rsul.ToHandActivateEffect(c,m)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(rsul.TokenOp(cm.op))
	c:RegisterEffect(e2) 
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op(c,e)
	rsef.SV_INDESTRUCTABLE(c,"battle",1,nil,rsreset.est,nil,{m,3})
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,6})
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
