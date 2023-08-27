--ジェネクス・サイバー・コントローラー
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.actcon)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	
end
function s.lcfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x2)
end
function s.lcheck(g,lc)
	return g:IsExists(s.lcfilter,1,nil)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg:GetFirst())
	return eg:GetCount()==1 and eg:GetFirst():IsSetCard(0x2)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	local te=Genex_summon_effect[tc:GetOriginalCode()]
	if not te then return false end
	local tg=te:GetTarget()
	if chk==0 then return te and (not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))) end
	tc:CreateEffectRelation(e)
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc then
		local te=Genex_summon_effect[tc:GetOriginalCode()]
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	e1:SetLabel(tc:GetCode())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackAbove(600) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-600)
	e:GetHandler():RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

-----------------------effect check-----------------------

Genex_summon_effect={}

function s.filter2(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) 
end

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter2,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
		cregister=Card.RegisterEffect
		eclone=Effect.Clone
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCode() and effect:GetCode()==EVENT_SPSUMMON_SUCCESS and Genex_spsummon_effect then
				Genex_summon_effect[card:GetOriginalCode()]=nil
			end
			if effect and effect:GetCode() and effect:GetCode()==EVENT_SUMMON_SUCCESS and effect:GetProperty()&EFFECT_FLAG_DELAY~=EFFECT_FLAG_DELAY then
				Genex_summon_effect[card:GetOriginalCode()]=eclone(effect)
			end
			Genex_spsummon_effect=false
			return 
		end
		Effect.Clone=function(effect)
			if effect and effect:GetCode() and effect:GetCode()==EVENT_SUMMON_SUCCESS and effect:GetProperty()&EFFECT_FLAG_DELAY~=EFFECT_FLAG_DELAY then
				Genex_spsummon_effect=true
			end
			return eclone(effect)
		end
		for tc in aux.Next(g) do
			Duel.CreateToken(0,tc:GetOriginalCode())
		end
		Card.RegisterEffect=cregister
		Effect.Clone=eclone
	end
	e:Reset()
end
