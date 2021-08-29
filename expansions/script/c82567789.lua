--方舟骑士·破碎雪崩 早露
function c82567789.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x825),aux.FilterBoolFunction(Card.IsType,TYPE_TUNER),1,true,true)
	--DEF change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567789,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_POSITION+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetCondition(c82567789.defcon)
	e1:SetTarget(c82567789.target)
	e1:SetOperation(c82567789.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82567789.negcon)
	e2:SetCost(c82567789.cost)
	e2:SetTarget(c82567789.negtg)
	e2:SetOperation(c82567789.negop)
	c:RegisterEffect(e2)
	--Spcial summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567789,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCost(c82567789.cost)
	e3:SetTarget(c82567789.natg)
	e3:SetOperation(c82567789.naop)
	c:RegisterEffect(e3)
	  

end
function c82567789.defcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c82567789.filter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsCanChangePosition() and c:IsCanBeEffectTarget()
end
function c82567789.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567789.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c82567789.filter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetDefense)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
end
function c82567789.activate(e,tp,eg,ep,ev,re,r,rp,g,tg,sg)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c82567789.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	local tg=g:GetMaxGroup(Card.GetDefense)
	if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local vg=sg:GetFirst()
			Duel.ChangePosition(vg,POS_FACEUP_DEFENSE)
				  local e2=Effect.CreateEffect(c)
				  e2:SetType(EFFECT_TYPE_SINGLE)
				  e2:SetCode(EFFECT_UPDATE_DEFENSE)
				  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
				  e2:SetValue(-1000)
				  vg:RegisterEffect(e2) 
				  local e3=Effect.CreateEffect(c)
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
				  vg:RegisterEffect(e3)
				  local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		vg:RegisterEffect(e4)
				
	else  local cg=tg:GetFirst()
	  Duel.ChangePosition(cg,POS_FACEUP_DEFENSE)
			  
				
					 local e4=Effect.CreateEffect(c)
					 e4:SetType(EFFECT_TYPE_SINGLE)
					 e4:SetCode(EFFECT_UPDATE_DEFENSE)
					 e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					 e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					 e4:SetValue(-1000)
					 cg:RegisterEffect(e4) 
					 local e5=Effect.CreateEffect(c)
					 e5:SetType(EFFECT_TYPE_SINGLE)
					 e5:SetCode(EFFECT_CANNOT_TRIGGER)
					 e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					 cg:RegisterEffect(e5)  
					  local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		cg:RegisterEffect(e4)
					
					 end
	 local c=e:GetHandler()
				local e6=Effect.CreateEffect(c)
					 e6:SetType(EFFECT_TYPE_SINGLE)
					 e6:SetCode(EFFECT_CANNOT_ATTACK)
					 e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					 c:RegisterEffect(e6)   
			 
  end
 end   
function c82567789.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c82567789.ngfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end

function c82567789.ngfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x825)
end
function c82567789.spfilter(c,e,tp)
		return c:IsSetCard(0x825) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end

function c82567789.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c82567789.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true  end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c82567789.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
	local mzc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(82567789,0)) then
	if Duel.IsPlayerAffectedByEffect(tp,59822133) 
	 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567789.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	   if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,TYPE_SPSUMMON,tp,tp,false,false,POS_FACEUP) 
	 if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		 local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
		 end
		end
	else Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   if mzc>1 then local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567789.spfilter),tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
		 if g:GetCount()>0 then
		 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		Duel.SpecialSummon(g,TYPE_SPSUMMON,tp,tp,false,false,POS_FACEUP) 
		 local tc=g:GetFirst()
		 while tc do
		  local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		 local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
		 tc=g:GetNext()
		 end
		end
	else local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567789.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		Duel.SpecialSummon(g,TYPE_SPSUMMON,tp,tp,false,false,POS_FACEUP)
		if tc then
		  local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		 local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
		 end
	end   
	end
	end
end
end

function c82567789.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c82567789.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack()
	local mzc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(82567789,0)) then
	if Duel.IsPlayerAffectedByEffect(tp,59822133) 
	 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567789.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	   if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,TYPE_SPSUMMON,tp,tp,false,false,POS_FACEUP) 
	   if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		 local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
		 end
		end
	else Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   if mzc>1 then local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567789.spfilter),tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
		 if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		Duel.SpecialSummon(g,TYPE_SPSUMMON,tp,tp,false,false,POS_FACEUP) 
		 local tc=g:GetFirst()
		 while tc do 
		  local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		 local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		 tc=g:GetNext()
		 end
		end
	else local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567789.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,TYPE_SPSUMMON,tp,tp,false,false,POS_FACEUP)
	   if tc then
		  local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		 local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
		 end
	end   
	end
	end
end
end

