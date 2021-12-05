--神代丰的铁骑 无敌小渠
function c64800100.initial_effect(c)
	c:SetSPSummonOnce(64800100)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1,1)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c64800100.spcost)
	c:RegisterEffect(e0)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetOperation(c64800100.desop)
	c:RegisterEffect(e1)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c64800100.lvcg)
	c:RegisterEffect(e2)
end

--spsm
function c64800100.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,64800097)
end

--e1
function c64800100.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAbleToExtra() then  
		op=Duel.SelectOption(tp,aux.Stringid(64800100,0),aux.Stringid(64800100,1))
	else
		op=0
	end
	Duel.Hint(HINT_CARD,1-tp,64800100)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	else
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end

--e2
function c64800100.lvcg(e,c,rc)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x641a) then
		return 4*65536+lv
	end
end
function c64800100.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x641a) then
		return 4*65536+lv
	end
end