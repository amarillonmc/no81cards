--数字冥魂[护卫者]
--1200203
local supercode=1200205 -- =登录系统卡号
local s,id,o=GetID()
function s.initial_effect(c)
	--spirit return
	--aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_HAND)
	--e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.smcon)
	e2:SetCost(s.smcost)
	e2:SetTarget(s.smtg)
	e2:SetOperation(s.smop)
	c:RegisterEffect(e2)
	--load effect
	local le2=e2:Clone()
	le2:SetDescription(aux.Stringid(supercode,1))
	le2:SetType(EFFECT_TYPE_QUICK_O)
	le2:SetCode(EVENT_CHAINING)
	le2:SetCondition(s.qcon)
	c:RegisterEffect(le2)

	--return to hand and search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetDescription(1104)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(Auxiliary.SpiritReturnConditionForced)
	e3:SetTarget(Auxiliary.SpiritReturnTargetForced)
	e3:SetOperation(s.rtop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCondition(Auxiliary.SpiritReturnConditionOptional)
	e4:SetTarget(Auxiliary.SpiritReturnTargetOptional)
	c:RegisterEffect(e4)
	--load effect
	local le4=e4:Clone()
	le4:SetDescription(aux.Stringid(supercode,1))
	le4:SetType(EFFECT_TYPE_QUICK_O)
	le4:SetCode(EVENT_CHAINING)
	le4:SetCondition(s.qcon)
	c:RegisterEffect(le4)
	--can not to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(s.sumop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP)
	c:RegisterEffect(e6)
end


function s.smcon(e,tp,eg,ep,ev,re,r,rp)
	--local ph=Duel.GetCurrentPhase()
	--return (ph==PHASE_DRAW or ph==PHASE_END) and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	--return ph==PHASE_END and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
end
function s.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	
	--hint1
	local he=Effect.CreateEffect(e:GetHandler())
	he:SetReset(RESET_PHASE+PHASE_END)
	he:SetDescription(aux.Stringid(id,3))
	he:SetType(EFFECT_TYPE_FIELD)
	he:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	he:SetTargetRange(1,0)
	Duel.RegisterEffect(he,tp)
	
end
function s.sumfilter(c,e,tp)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT) and not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)~=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.distg)
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SPIRIT)
end
function s.distg(e,c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end

function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x6240) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	--重定向
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(LOCATION_DECK,0)
	e1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(e1,tp)
	
	--hint2
	local he=Effect.CreateEffect(e:GetHandler())
	he:SetReset(RESET_PHASE+PHASE_END)
	he:SetDescription(aux.Stringid(id,4))
	he:SetType(EFFECT_TYPE_FIELD)
	he:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	he:SetTargetRange(1,0)
	Duel.RegisterEffect(he,tp)
	
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

function s.tglimit(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsLocation(LOCATION_DECK)
end

function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,supercode)>0 and ep~=tp
end