--百夫骑兵·徽记
local m=11513085
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c11513085.pspcon)
	e0:SetOperation(c11513085.pspop)
	c:RegisterEffect(e0)
	--synclv
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetValue(c11513085.synclv)
	--c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c11513085.tnval)
	c:RegisterEffect(e2)
	--spsummon from szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11513085,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,11513085)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCondition(c11513085.spcon)
	e3:SetTarget(c11513085.sptg)
	e3:SetOperation(c11513085.spop)
	c:RegisterEffect(e3)
end
function c11513085.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end

function c11513085.stfilter(c,e,tp)
	return c:IsSetCard(0x1a2) and c:IsType(TYPE_MONSTER)
end
function c11513085.setfilter(c,tp)
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	Group.AddCard(g,c)
	return c:IsSetCard(0x1a2) and Duel.GetMZoneCount(tp,g)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:FilterCount(Card.IsControler,nil,tp) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=g:FilterCount(Card.IsControler,nil,1-tp)
end
function c11513085.pspcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c11513085.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c11513085.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,c11513085.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Group.Merge(g,g:GetFirst():GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_ONFIELD))
	local tc=g:GetFirst()
	Debug.Message(g:GetCount())
	while tc do
			 Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetCode(EFFECT_CHANGE_TYPE)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			 e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			 tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11513085.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c11513085.splimit(e,c,tp,sumtp,sumpos)
	return c:IsCode(11513085)
end
function c11513085.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c11513085.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11513085,0x1a2,TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER,3000,3000,8,RACE_SPELLCASTER,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11513085.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end




