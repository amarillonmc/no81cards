--陷阵营的战前仪式
function c9330016.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9330016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9330016.condition2)
	e1:SetTarget(c9330016.target)
	e1:SetOperation(c9330016.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c9330016.actcon)
	c:RegisterEffect(e0)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c9330016.condition1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf93))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(1,1)
	e4:SetValue(c9330016.aclimit)
	c:RegisterEffect(e4)
	--cannot remove
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e5:SetValue(c9330016.aclimit2)
	c:RegisterEffect(e5)
	--set/to hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(aux.exccon)
	e6:SetCountLimit(1,9330110+EFFECT_COUNT_CODE_DUEL)
	e6:SetCost(c9330016.thcost)
	e6:SetTarget(c9330016.settg)
	e6:SetOperation(c9330016.setop)
	c:RegisterEffect(e6)
end
function c9330016.actcon(e,tp,eg,ep,ev,re,r,rp)
	local  k=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(k,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(k,LOCATION_ONFIELD,0)
end
function c9330016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,9330016,0xaf93,0x21,2400,1000,6,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9330016.filter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330016.mfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c9330016.filter1(c,e,tp)
	return c:IsSetCard(0xaf93)
end
function c9330016.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,9330016,0xaf93,0x21,2400,1000,6,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP) 
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(c9330016.mfilter,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
	if  Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c9330016.filter1,e,tp,mg1,nil,Card.GetLevel,"Equal")
		and Duel.IsExistingMatchingCard(c9330016.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9330016,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c9330016.filter1,e,tp,mg1,nil,Card.GetLevel,"Equal")
		local tc=tg:GetFirst()
		if tc then
			local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
			end
		end
	end
end
function c9330016.condition1(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9330016.condition2(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_STANDBY or ph==PHASE_MAIN1
end
function c9330016.etarget(e,c)
	return c:IsFaceup() and c:IsSetCard(0xaf93) and not c:IsCode(9330016)
end
function c9330016.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER)
end
function c9330016.aclimit2(e,c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c9330016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330016.setfilter(c)
	if not (c:IsSetCard(0xaf93) and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsCode(9330016)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9330016.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330016.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9330016.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330016.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end












