--铁战灵兽 M暴雪王
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,33200901) 
	--spesm
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x332a),6,99,s.xyzovfilter,aux.Stringid(id,1),99,s.xyzop)
	c:EnableReviveLimit()
	--stg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.tg)
	c:RegisterEffect(e1) 
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--xyz
function s.xyzovfilter(c)
	return c:IsFaceup() and c:IsCode(33200901)
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200052)==0 
	and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,33200052,nil,EFFECT_FLAG_OATH,1)
end

--e1
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:GetCounter(0x132a)>0 end,tp,0,LOCATION_MZONE,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetCounter(0x132a)>0 end,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 and e:GetHandler():IsFaceup() then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_OATH,1)
		Group.ForEach(sg,s.re(tc,c),e:GetHandler())
	end
end
function s.re(tc,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetCondition(s.actcon)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:GetFlagEffect(id)>0 end,tp,0,LOCATION_MZONE,1,nil)
end

--e2
function s.ctfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsFaceup() and c:IsCanAddCounter(0x132a,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.ctfilter,1,nil,1-tp) and not eg:IsContains(e:GetHandler()) then 
		local c=e:GetHandler()
		local g=eg:Filter(s.ctfilter,nil,1-tp)
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			if tc:IsCanAddCounter(0x132a,2) then
				tc:AddCounter(0x132a,2)
			end
		end
	end
end
