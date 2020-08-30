--白金·珊瑚海岸收藏-灿阳朝露
function c79029286.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1) 
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029092)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c79029286.atkcon)
	e3:SetCost(c79029286.atkcost)
	e3:SetOperation(c79029286.atkop)
	c:RegisterEffect(e3) 
	--target/atk protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c79029286.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c79029286.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c79029286.pentg)
	e4:SetOperation(c79029286.penop)
	c:RegisterEffect(e4)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(79029286,5))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,79029286)
	e3:SetCost(c79029286.spcost)
	e3:SetTarget(c79029286.sptg)
	e3:SetOperation(c79029286.spop)
	c:RegisterEffect(e3)
	--p
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029286,4))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029286.pcon)
	e1:SetOperation(c79029286.pop)
	c:RegisterEffect(e1)
end
c79029286.material_type=TYPE_SYNCHRO
function c79029286.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetAttack()>0
end
function c79029286.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(79029286)==0 end
	c:RegisterFlagEffect(79029286,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c79029286.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	Debug.Message("一起攻过来也可以，反正你们都很弱。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029286,0))
	end
end
function c79029286.atlimit(e,c)
	return c~=e:GetHandler()
end
function c79029286.tglimit(e,c)
	return c~=e:GetHandler()
end
function c79029286.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029286.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("这里的环境，感觉意外的不错嘛~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029286,1))
	end
end
function c79029286.spfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c79029286.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029286.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,nil) end
	local rg=Duel.SelectMatchingCard(tp,c79029286.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c79029286.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029286.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	Debug.Message("——如此一来，便是将军喽！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029286,3))
	end
end
function c79029286.pzfil(c,e,tp,lsc,rsc)
	local lv=c:GetLevel()
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and lv>lsc and lv<rsc 
end
function c79029286.pcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=2 then return false end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local xp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c79029286.pzfil,tp,LOCATION_DECK,0,1,nil,e,tp,lsc,rsc) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0
end
function c79029286.pop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("接下来，会发生一场有趣的战斗吗~？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029286,2))
	Duel.Hint(HINT_CARD,0,79029286)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local x=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
	g=Duel.SelectMatchingCard(tp,c79029286.pzfil,tp,LOCATION_DECK,0,1,x,nil,e,tp,lsc,rsc)
	else 
	g=Duel.SelectMatchingCard(tp,c79029286.pzfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,lsc,rsc)
	end
	Duel.HintSelection(Group.FromCards(Duel.GetFieldCard(tp,LOCATION_PZONE,0)))
	Duel.HintSelection(Group.FromCards(Duel.GetFieldCard(tp,LOCATION_PZONE,1)))
	Duel.SpecialSummon(g,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	Duel.Damage(tp,g:GetCount()*1000,REASON_EFFECT)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c79029286.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c79029286.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end




