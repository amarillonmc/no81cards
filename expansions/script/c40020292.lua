--天觉龙 艾格
local s,id=GetID()
s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)	  
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)	 
	e1:SetCondition(s.excon)
	e1:SetTarget(s.extg)
	e1:SetOperation(s.exop)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,40020295+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not s.AwakenedDragon(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.sfilter(c)
	return c:IsFaceup() and s.AwakenedDragon(c) and not c:IsCode(id)and c:IsType(TYPE_PENDULUM)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.sfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function s.excon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function s.exfilter(c)
	return s.AwakenedDragon(c)   
		and c:IsType(TYPE_MONSTER)  
		and not c:IsCode(id)			
		and not c:IsForbidden()
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
	end
end
-- 把组 g 当作灵摆卡使用加入额外卡组
function s.SendGroupToExtraAsPendulum(g,tp,reason,e)
	local handler = e and e:GetHandler() or nil
	local tc=g:GetFirst()
	while tc do
		if not tc:IsType(TYPE_PENDULUM) then
			local e1=Effect.CreateEffect(handler)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_PENDULUM)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		tc=g:GetNext()
	end
	Duel.SendtoExtraP(g,tp,reason)
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		s.SendGroupToExtraAsPendulum(g,tp,REASON_EFFECT,e)
	end
end
