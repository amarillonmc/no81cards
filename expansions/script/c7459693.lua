--廷达魔三角之女王
local s,id,o=GetID()
function s.initial_effect(c)
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end
function s.spfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.spfilter2(c)
	return c:IsSetCard(0x10b) and c:IsType(TYPE_MONSTER)
end
function s.fselect(g,tp)
	return aux.mzctcheck(g,tp) and aux.gffcheck(g,Card.IsType,TYPE_SPELL+TYPE_TRAP,s.spfilter2,nil)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,c)
	return g:CheckSubGroup(s.fselect,2,2,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,s.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
	--confirm
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sprrop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e:GetHandler():RegisterEffect(e1)
end
function s.sprrop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFacedown() then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function s.thfilter(c)
	return s.setcard_table[c:GetCode()] and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.sspfilter(c,e,tp)
	return c:IsCode(31759689,75119040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.sspfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.sspfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)~=0 and g:GetFirst():IsFacedown() then
		Duel.ConfirmCards(1-tp,g:GetFirst())
	end
end

s.globle_check={}
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check[tp] then
		s.globle_check[tp]=true
		--setcard mentioned
		local card=e:GetHandler()
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsCode),tp,0xff,0,nil,id)
		cregister=Card.RegisterEffect
		csetcard=Card.IsSetCard
		disexistingtarget=Duel.IsExistingTarget
		disexistingmatchingcard=Duel.IsExistingMatchingCard
		Duel.IsExistingTarget=function(f,tp,s,o,count,c_g_n,...)
		  pcall(f(card,...))
		  return disexistingtarget(f,tp,0xff,0xff,count,c_g_n,...)
		end
		Duel.IsExistingMatchingCard=function(f,tp,s,o,count,c_g_n,...)
		  pcall(f(card,...))
		  return disexistingmatchingcard(f,tp,0xff,0xff,count,c_g_n,...)
		end
		
		s.card_function={Card.IsAbleToChangeControler,Card.IsAbleToDeck,Card.IsAbleToDeckAsCost,Card.IsAbleToDeckOrExtraAsCost,Card.IsAbleToDecreaseAttackAsCost,Card.IsAbleToDecreaseDefenseAsCost,Card.IsAbleToExtra,Card.IsAbleToExtraAsCost,Card.IsAbleToGrave,Card.IsAbleToGraveAsCost,Card.IsAbleToHand,Card.IsAbleToHandAsCost,Card.IsAbleToRemove,Card.IsAbleToRemoveAsCost,Card.IsAllColumn,Card.IsAttack,Card.IsAttackable,Card.IsAttackAbove,Card.IsAttackAbove,Card.IsAttackBelow,Card.IsAttackPos,Card.IsAttribute,Card.IsCanAddCounter,Card.IsCanBeBattleTarget,Card.IsCanBeEffectTarget,Card.IsCanBeFusionMaterial,Card.IsCanBeLinkMaterial,Card.IsCanBeRitualMaterial,Card.IsCanBeSpecialSummoned,Card.IsCanBeSynchroMaterial,Card.IsCanBeXyzMaterial,Card.IsCanChangePosition,Card.IsCanRemoveCounter,Card.IsCanTurnSet,Card.IsChainAttackable,Card.IsCode,Card.IsControler,Card.IsControlerCanBeChanged,Card.IsDefense,Card.IsDefenseAbove,Card.IsDefenseBelow,Card.IsDefensePos,Card.IsDestructable,Card.IsDirectAttacked,Card.IsDisabled,Card.IsDiscardable,Card.IsDualState,Card.IsExtraLinkState,Card.IsFacedown,Card.IsFaceup,Card.IsForbidden,Card.IsFusionAttribute,Card.IsFusionCode,Card.IsFusionSetCard,Card.IsFusionSummonableCard,Card.IsFusionType,Card.IsHasCardTarget,Card.IsImmuneToEffect,Card.IsLevel,Card.IsLevelAbove,Card.IsLevelBelow,Card.IsLink,Card.IsLinkAbove,Card.IsLinkAttribute,Card.IsLinkBelow,Card.IsLinkCode,Card.IsLinkMarker,Card.IsLinkRace,Card.IsLinkSetCard,Card.IsLinkState,Card.IsLinkType,Card.IsLocation,Card.IsMSetable,Card.IsNotTuner,Card.IsOnField,Card.IsPosition,Card.IsPreviousLocation,Card.IsPreviousPosition,Card.IsPreviousSetCard,Card.IsPublic,Card.IsRace,Card.IsRank,Card.IsRankAbove,Card.IsRankBelow,Card.IsReason,Card.IsRelateToBattle,Card.IsRelateToCard,Card.IsRelateToChain,Card.IsRelateToEffect,Card.IsReleasable,Card.IsReleasableByEffect,Card.IsRitualType,Card.IsSetCard,Card.IsSpecialSummonable,Card.IsSSetable,Card.IsStatus,Card.IsSummonable,Card.IsSummonableCard,Card.IsSummonType,Card.IsSynchroSummonable,Card.IsSynchroType,Card.IsType,Card.IsXyzLevel,Card.IsXyzSummonable,Card.IsXyzSummonableByRose,Card.IsXyzType}
		
		local empty_function_change={}
		for i=1,150 do
			empty_function_change[i]=function(card,...) return true end
		end
		--Debug.Message("0")
		s.change_card_function(empty_function_change)
		--Debug.Message("1")
		s.setcard_table={}
		s.setcard_table[id]=true
		s.ev=0
		s.c=false
		s.code=0
		s.player=tp
		s.setcard=false
		s.re=Effect.CreateEffect(e:GetHandler())
		cregister(e:GetHandler(),s.re)
		--[[Card.RegisterEffect=function(card,effect,flag)
		  if effect and (effect:IsActivated()) then
			  local cost=effect:GetCost()
			  local con=effect:GetCondition()
			  local tg=effect:GetTarget()
			  local eg=Group.CreateGroup()
			  cregister(card,effect,flag)
			  --
			  if cost then pcall(cost,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0) end
			  --if con then con() end
			  if tg then pcall(tg,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0) end
			  effect:Reset()
		  end
		  return 
		end]]
		function s.setcard_check_filter(effect)
			if effect and (effect:IsActivated()) then
				local cost=effect:GetCost()
				local con=effect:GetCondition()
				local tg=effect:GetTarget()
				local eg=Group.CreateGroup()
				--
				if cost then pcall(cost,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0) end
				--if con then con() end
				if tg then pcall(tg,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0,0) pcall(tg,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0,card) end
			end
			return false
		end
		Card.IsSetCard=function(card,setname,...)
		  local val={...}
		  if #val>0 then
			  for i=1,#val do
				  if val[i] and val[i]&0x10b==0x10b then
					  s.setcard=true 
				  end
			  end
		  end
		  if setname&0x10b==0x10b then
			 s.setcard=true 
		  end
		  return 
		end
		for tc in aux.Next(g) do
			s.setcard=false 
			--[[local effect=tc:GetActivateEffect()
			if effect and (effect:IsActivated()) then
				local cost=effect:GetCost()
				local con=effect:GetCondition()
				local tg=effect:GetTarget()
				local eg=Group.CreateGroup()
				--
				if cost then pcall(cost,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0) end
				--if con then con() end
				if tg then pcall(tg,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0,0) pcall(tg,effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0,1) end
			end]]
			local boolean=tc:IsOriginalEffectProperty(s.setcard_check_filter)
			--Duel.CreateToken(0,tc:GetOriginalCode())
			if s.setcard then
				s.setcard_table[tc:GetOriginalCode()]=true
			end
		end
		s.change_card_function(s.card_function)
		--Debug.Message("3")
		Duel.IsExistingTarget=disexistingtarget
		Duel.IsExistingMatchingCard=disexistingmatchingcard
		Card.RegisterEffect=cregister
		Card.IsSetCard=csetcard
	end
	e:Reset()
end

function s.change_card_function(table)
	local i=1
	Card.IsAbleToChangeControler=table[i]   i=i+1
	Card.IsAbleToDeck=table[i]  i=i+1
	Card.IsAbleToDeckAsCost=table[i]	i=i+1
	Card.IsAbleToDeckOrExtraAsCost=table[i] i=i+1
	Card.IsAbleToDecreaseAttackAsCost=table[i]  i=i+1
	Card.IsAbleToDecreaseDefenseAsCost=table[i] i=i+1
	Card.IsAbleToExtra=table[i] i=i+1
	Card.IsAbleToExtraAsCost=table[i]   i=i+1
	Card.IsAbleToGrave=table[i] i=i+1
	Card.IsAbleToGraveAsCost=table[i]   i=i+1
	Card.IsAbleToHand=table[i]  i=i+1
	Card.IsAbleToHandAsCost=table[i]	i=i+1
	Card.IsAbleToRemove=table[i]	i=i+1
	Card.IsAbleToRemoveAsCost=table[i]  i=i+1
	Card.IsAllColumn=table[i]   i=i+1
	Card.IsAttack=table[i]  i=i+1
	Card.IsAttackable=table[i]  i=i+1
	Card.IsAttackAbove=table[i] i=i+1
	Card.IsAttackAbove=table[i] i=i+1
	Card.IsAttackBelow=table[i] i=i+1
	Card.IsAttackPos=table[i]   i=i+1
	Card.IsAttribute=table[i]   i=i+1
	Card.IsCanAddCounter=table[i]   i=i+1
	Card.IsCanBeBattleTarget=table[i]   i=i+1
	Card.IsCanBeEffectTarget=table[i]   i=i+1
	Card.IsCanBeFusionMaterial=table[i] i=i+1
	Card.IsCanBeLinkMaterial=table[i]   i=i+1
	Card.IsCanBeRitualMaterial=table[i] i=i+1
	Card.IsCanBeSpecialSummoned=table[i]	i=i+1
	Card.IsCanBeSynchroMaterial=table[i]	i=i+1
	Card.IsCanBeXyzMaterial=table[i]	i=i+1
	Card.IsCanChangePosition=table[i]   i=i+1
	Card.IsCanRemoveCounter=table[i]	i=i+1
	Card.IsCanTurnSet=table[i]  i=i+1
	Card.IsChainAttackable=table[i] i=i+1
	Card.IsCode=table[i]	i=i+1
	Card.IsControler=table[i]   i=i+1
	Card.IsControlerCanBeChanged=table[i]   i=i+1
	Card.IsDefense=table[i] i=i+1
	Card.IsDefenseAbove=table[i]	i=i+1
	Card.IsDefenseBelow=table[i]	i=i+1
	Card.IsDefensePos=table[i]  i=i+1
	Card.IsDestructable=table[i]	i=i+1
	Card.IsDirectAttacked=table[i]  i=i+1
	Card.IsDisabled=table[i]	i=i+1
	Card.IsDiscardable=table[i] i=i+1
	Card.IsDualState=table[i]   i=i+1
	Card.IsExtraLinkState=table[i]  i=i+1
	Card.IsFacedown=table[i]	i=i+1
	Card.IsFaceup=table[i]  i=i+1
	Card.IsForbidden=table[i]   i=i+1
	Card.IsFusionAttribute=table[i] i=i+1
	Card.IsFusionCode=table[i]  i=i+1
	Card.IsFusionSetCard=table[i]   i=i+1
	Card.IsFusionSummonableCard=table[i]	i=i+1
	Card.IsFusionType=table[i]  i=i+1
	Card.IsHasCardTarget=table[i]   i=i+1
	Card.IsImmuneToEffect=table[i]  i=i+1
	Card.IsLevel=table[i]   i=i+1
	Card.IsLevelAbove=table[i]  i=i+1
	Card.IsLevelBelow=table[i]  i=i+1
	Card.IsLink=table[i]	i=i+1
	Card.IsLinkAbove=table[i]   i=i+1
	Card.IsLinkAttribute=table[i]   i=i+1
	Card.IsLinkBelow=table[i]   i=i+1
	Card.IsLinkCode=table[i]	i=i+1
	Card.IsLinkMarker=table[i]  i=i+1
	Card.IsLinkRace=table[i]	i=i+1
	Card.IsLinkSetCard=table[i] i=i+1
	Card.IsLinkState=table[i]   i=i+1
	Card.IsLinkType=table[i]	i=i+1
	Card.IsLocation=table[i]	i=i+1
	Card.IsMSetable=table[i]	i=i+1
	Card.IsNotTuner=table[i]	i=i+1
	Card.IsOnField=table[i] i=i+1
	Card.IsPosition=table[i]	i=i+1
	Card.IsPreviousLocation=table[i]	i=i+1
	Card.IsPreviousPosition=table[i]	i=i+1
	Card.IsPreviousSetCard=table[i] i=i+1
	Card.IsPublic=table[i]  i=i+1
	Card.IsRace=table[i]	i=i+1
	Card.IsRank=table[i]	i=i+1
	Card.IsRankAbove=table[i]   i=i+1
	Card.IsRankBelow=table[i]   i=i+1
	Card.IsReason=table[i]  i=i+1
	Card.IsRelateToBattle=table[i]  i=i+1
	Card.IsRelateToCard=table[i]	i=i+1
	Card.IsRelateToChain=table[i]   i=i+1
	Card.IsRelateToEffect=table[i]  i=i+1
	Card.IsReleasable=table[i]  i=i+1
	Card.IsReleasableByEffect=table[i]  i=i+1
	Card.IsRitualType=table[i]  i=i+1
	Card.IsSetCard=table[i] i=i+1
	Card.IsSpecialSummonable=table[i]   i=i+1
	Card.IsSSetable=table[i]	i=i+1
	Card.IsStatus=table[i]  i=i+1
	Card.IsSummonable=table[i]  i=i+1
	Card.IsSummonableCard=table[i]  i=i+1
	Card.IsSummonType=table[i]  i=i+1
	Card.IsSynchroSummonable=table[i]   i=i+1
	Card.IsSynchroType=table[i] i=i+1
	Card.IsType=table[i]	i=i+1
	Card.IsXyzLevel=table[i]	i=i+1
	Card.IsXyzSummonable=table[i]   i=i+1
	Card.IsXyzSummonableByRose=table[i] i=i+1
	Card.IsXyzType=table[i] i=i+1
end
