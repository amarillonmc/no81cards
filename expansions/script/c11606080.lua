--已化为绝海滋养的巨兽
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e1)
	--双方主要阶段才能发动。从手卡把1只「绝海滋养」怪兽召唤。
	--「魔弹-血色之冠」「抗锯齿星人」
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
	--自己作「绝海滋养」怪兽上级召唤的场合，可以把自己场上任意数量怪兽和对方场上1张卡解放来上级召唤。
	--「帝王的烈旋」「吸血鬼吸食者」
	local ce=Effect.CreateEffect(c)
	ce:SetType(EFFECT_TYPE_FIELD)
	ce:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ce:SetCode(id)
	ce:SetRange(LOCATION_SZONE)
	ce:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(ce)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.rcon)
	e3:SetTarget(s.rtg)
	e3:SetCountLimit(1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCondition(s.gecon)
	e4:SetTarget(s.getg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.sumfilter(c)
	return c:IsSetCard(0x5225) and c:IsSummonable(true,nil)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.gecon(e)
	return Duel.GetFlagEffect(tp,id)==0
end

function s.getg(e,c)
	return c:IsSetCard(0x5225) and c:IsType(TYPE_MONSTER)
end
function s.rcon(e)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,id)~=0 then return false end
	if not e:CheckCountLimit(e:GetHandlerPlayer()) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
	return true
end
function s.rtg(e,c)
	return c:IsHasEffect(id)
end