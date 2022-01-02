--方舟骑士-阿米娅
c29065500.named_with_Arknight=1
function c29065500.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6616912,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c29065500.ntcon)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065500,0)) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29065500)
	e2:SetCost(c29065500.cocost)
	e2:SetTarget(c29065500.cotg)
	e2:SetOperation(c29065500.coop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c29065500.cfilter(c)
	return c:IsFacedown() or not (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065500.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c29065500.cfilter,tp,LOCATION_MZONE,0,1,nil))
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c29065500.efil(c,e,tp,eg,ep,ev,re,r,rp) 
	if not ((c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and not c:IsCode(29065500)) then return false end 
	local m=_G["c"..c:GetCode()]
	if not m then return false end 
	local te=m.summon_effect	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
 end
function c29065500.cocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065500.efil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local tc=Duel.SelectMatchingCard(tp,c29065500.efil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,re,r,rp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabelObject(tc)
end
function c29065500.cotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	tc:CreateEffectRelation(e)
	local m=_G["c"..tc:GetCode()]
	local te=m.summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c29065500.coop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
		local m=_G["c"..tc:GetCode()]
		local te=m.summon_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) 
end
end