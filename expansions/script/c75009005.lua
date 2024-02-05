--平常心的最高峰 琳&芙萝莉娜
function c75009005.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(function(e)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster(tp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and a and a==e:GetHandler() and d end) 
	e2:SetTarget(function(e,c)
	local bc=e:GetHandler():GetBattleTarget() 
	return bc and c==bc and c:GetBaseAttack()>c:GetAttack() and c:GetBaseDefense()>c:GetDefense() end) 
	e2:SetValue(function(e,c) 
	return c:GetBaseAttack() end)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EFFECT_SET_BASE_DEFENSE) 
	e3:SetValue(function(e,c) 
	return c:GetBaseDefense() end) 
	c:RegisterEffect(e3) 
	--pos 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75009005,0)) 
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e3:SetTarget(c75009005.postg)
	e3:SetOperation(c75009005.posop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75009005,0)) 
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCondition(c75009005.poscon)
	e4:SetTarget(c75009005.postg)
	e4:SetOperation(c75009005.posop)
	c:RegisterEffect(e4) 
	--spsummon
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,75009005) 
	e4:SetTarget(c75009005.sptg)
	e4:SetOperation(c75009005.spop)
	c:RegisterEffect(e4)
end
function c75009005.poscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c75009005.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_ONFIELD)
end 
function c75009005.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then 
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end 
end 
function c75009005.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x75e,0x755) and not c:IsCode(75009005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c75009005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75009005.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c75009005.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75009005.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0  and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then 
		local b1=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		if (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(75009005,4)) then 
			local op=2 
			if b1 and b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(75009005,2),aux.Stringid(75009005,3)) 
			elseif b1 then 
				op=Duel.SelectOption(tp,aux.Stringid(75009005,2))
			elseif b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(75009005,3))+1
			end 
			if op==0 then 
				local sc=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst() 
				Duel.XyzSummon(tp,sc,nil)
			elseif op==1 then 
				local sc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst() 
				Duel.SynchroSummon(tp,sc,nil)
			end 
		end 
	end
end








