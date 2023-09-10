--提 灯 的 弗 洛 伦 斯
local m=22348311
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348311,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c22348311.spcon)
	e1:SetCost(c22348311.spcost)
	e1:SetTarget(c22348311.sptg)
	e1:SetOperation(c22348311.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c22348311.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage 0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348311,11))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c22348311.rectg)
	e4:SetOperation(c22348311.recop)
	c:RegisterEffect(e4)
end
function c22348311.cfilter(c,e)
	local tp=e:GetHandler():GetControler()
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp)
end
function c22348311.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348311.cfilter,1,nil,e)
end
function c22348311.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22348311.remfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()
end
function c22348311.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Group.Filter(eg,c22348311.cfilter,nil,e)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return true
	end
	e:SetLabel(0)
	local g=tg:Filter(c22348311.remfilter,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,1-tp,LOCATION_REMOVED)
end
function c22348311.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_REMOVED) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c22348311.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local tgg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=tgg:Filter(c22348311.spfilter,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	end
end
function c22348311.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function c22348311.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
	local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*300
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c22348311.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*300
	Duel.Recover(p,rec,REASON_EFFECT)
end
