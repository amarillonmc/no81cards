--雪域生灵们
local s,id,o=GetID()
function s.initial_effect(c)
	--Enable Revive Limit
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	--Equip from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
end
function s.mfilter(c)
	return c:IsLevel(3) and c:IsSetCard(0x5226)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain() and tc:IsFaceup() then
		if Duel.Equip(tp,c,tc) then
			--Equip Limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(s.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
			--ATK down
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			--DEF down
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e3)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
