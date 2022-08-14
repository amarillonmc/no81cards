--绚丽狂欢-深蓝时间
local m = 12895012
local cm=_G["c"..m]
function c12895012.initial_effect(c)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(12895012)
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
    e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(cm.retcon)
	e4:SetTarget(cm.rettg)
	e4:SetOperation(cm.retop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(12895012)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
    local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(cm.rcop)
	c:RegisterEffect(e9)
end
function cm.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsType(TYPE_MONSTER) 
end
--素材
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--效果1
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
        Duel.SendtoGrave(c,REASON_EFFECT)  
    else
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--效果5



function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return not c:IsSetCard(0xa74) 
end  
--特招限制
