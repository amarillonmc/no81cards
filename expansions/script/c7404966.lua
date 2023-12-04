--开辟的暗黑骑士 盖亚
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
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,8))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,6))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,7))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.rmtg2)
	e5:SetOperation(s.rmop2)
	c:RegisterEffect(e5)
	
end
s.globle_check={}
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check[tp] then
		s.globle_check[tp]=true
		--setcard mentioned
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsCode),0,0xff,0,nil,id)
		cregister=Card.RegisterEffect
		csetcard=Card.IsSetCard
		disexistingtarget=Duel.IsExistingTarget
		disexistingmatchingcard=Duel.IsExistingMatchingCard
		Duel.IsExistingTarget=function(f,tp,s,o,count,c_g_n,...)
		  return Duel.IsExistingMatchingCard(f,tp,s,o,count,c_g_n,...)
		end
		Duel.IsExistingMatchingCard=function(f,tp,s,o,count,c_g_n,...)
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
		Card.RegisterEffect=function(card,effect,flag)
		  if effect and (effect:IsActivated()) then
			  local cost=effect:GetCost()
			  local con=effect:GetCondition()
			  local tg=effect:GetTarget()
			  local eg=Group.CreateGroup()
			  cregister(card,effect,flag)
			  --
			  if cost then cost(effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0) end
			  --if con then con() end
			  if tg then tg(effect,s.player,eg,s.player,s.ev,s.re,r,s.player,0) end
			  effect:Reset()
		  end
		  return 
		end
		Card.IsSetCard=function(card,setname,...)
		  local val={...}
		  if #val>0 then
			  for i=1,#val do
				  if val[i] and val[i]&0xbd==0xbd then
					  s.setcard=true 
				  end
			  end
		  end
		  if setname&0xbd==0xbd then
			 s.setcard=true 
		  end
		  return 
		end
		for tc in aux.Next(g) do
			s.setcard=false 
			Duel.CreateToken(0,tc:GetOriginalCode())
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

function s.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct>0 
		and ct==Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and eg:IsExists(Card.IsSetCard,1,nil,0x10cf)
		and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsSetCard,nil,0x10cf)
	local rc=g:GetFirst()
	if not rc then return end
	--tohand
	local e0=Effect.CreateEffect(rc)
	e0:SetDescription(aux.Stringid(id,3))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.thtg)
	e0:SetOperation(s.thop)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e0,true)
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(rc)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.rmtg2)
	e2:SetOperation(s.rmop2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
end
function s.thfilter(c)
	return s.setcard_table[c:GetCode()] and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp,POS_FACEDOWN)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	local tc=sg:GetFirst()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.retcon)
	e1:SetOperation(s.retop)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	else
		return Duel.GetTurnPlayer()~=tp
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function s.change_card_function(table)
	local i=1
	Card.IsAbleToChangeControler=table[i]	i=i+1
	Card.IsAbleToDeck=table[i]	i=i+1
	Card.IsAbleToDeckAsCost=table[i]	i=i+1
	Card.IsAbleToDeckOrExtraAsCost=table[i]	i=i+1
	Card.IsAbleToDecreaseAttackAsCost=table[i]	i=i+1
	Card.IsAbleToDecreaseDefenseAsCost=table[i]	i=i+1
	Card.IsAbleToExtra=table[i]	i=i+1
	Card.IsAbleToExtraAsCost=table[i]	i=i+1
	Card.IsAbleToGrave=table[i]	i=i+1
	Card.IsAbleToGraveAsCost=table[i]	i=i+1
	Card.IsAbleToHand=table[i]	i=i+1
	Card.IsAbleToHandAsCost=table[i]	i=i+1
	Card.IsAbleToRemove=table[i]	i=i+1
	Card.IsAbleToRemoveAsCost=table[i]	i=i+1
	Card.IsAllColumn=table[i]	i=i+1
	Card.IsAttack=table[i]	i=i+1
	Card.IsAttackable=table[i]	i=i+1
	Card.IsAttackAbove=table[i]	i=i+1
	Card.IsAttackAbove=table[i]	i=i+1
	Card.IsAttackBelow=table[i]	i=i+1
	Card.IsAttackPos=table[i]	i=i+1
	Card.IsAttribute=table[i]	i=i+1
	Card.IsCanAddCounter=table[i]	i=i+1
	Card.IsCanBeBattleTarget=table[i]	i=i+1
	Card.IsCanBeEffectTarget=table[i]	i=i+1
	Card.IsCanBeFusionMaterial=table[i]	i=i+1
	Card.IsCanBeLinkMaterial=table[i]	i=i+1
	Card.IsCanBeRitualMaterial=table[i]	i=i+1
	Card.IsCanBeSpecialSummoned=table[i]	i=i+1
	Card.IsCanBeSynchroMaterial=table[i]	i=i+1
	Card.IsCanBeXyzMaterial=table[i]	i=i+1
	Card.IsCanChangePosition=table[i]	i=i+1
	Card.IsCanRemoveCounter=table[i]	i=i+1
	Card.IsCanTurnSet=table[i]	i=i+1
	Card.IsChainAttackable=table[i]	i=i+1
	Card.IsCode=table[i]	i=i+1
	Card.IsControler=table[i]	i=i+1
	Card.IsControlerCanBeChanged=table[i]	i=i+1
	Card.IsDefense=table[i]	i=i+1
	Card.IsDefenseAbove=table[i]	i=i+1
	Card.IsDefenseBelow=table[i]	i=i+1
	Card.IsDefensePos=table[i]	i=i+1
	Card.IsDestructable=table[i]	i=i+1
	Card.IsDirectAttacked=table[i]	i=i+1
	Card.IsDisabled=table[i]	i=i+1
	Card.IsDiscardable=table[i]	i=i+1
	Card.IsDualState=table[i]	i=i+1
	Card.IsExtraLinkState=table[i]	i=i+1
	Card.IsFacedown=table[i]	i=i+1
	Card.IsFaceup=table[i]	i=i+1
	Card.IsForbidden=table[i]	i=i+1
	Card.IsFusionAttribute=table[i]	i=i+1
	Card.IsFusionCode=table[i]	i=i+1
	Card.IsFusionSetCard=table[i]	i=i+1
	Card.IsFusionSummonableCard=table[i]	i=i+1
	Card.IsFusionType=table[i]	i=i+1
	Card.IsHasCardTarget=table[i]	i=i+1
	Card.IsImmuneToEffect=table[i]	i=i+1
	Card.IsLevel=table[i]	i=i+1
	Card.IsLevelAbove=table[i]	i=i+1
	Card.IsLevelBelow=table[i]	i=i+1
	Card.IsLink=table[i]	i=i+1
	Card.IsLinkAbove=table[i]	i=i+1
	Card.IsLinkAttribute=table[i]	i=i+1
	Card.IsLinkBelow=table[i]	i=i+1
	Card.IsLinkCode=table[i]	i=i+1
	Card.IsLinkMarker=table[i]	i=i+1
	Card.IsLinkRace=table[i]	i=i+1
	Card.IsLinkSetCard=table[i]	i=i+1
	Card.IsLinkState=table[i]	i=i+1
	Card.IsLinkType=table[i]	i=i+1
	Card.IsLocation=table[i]	i=i+1
	Card.IsMSetable=table[i]	i=i+1
	Card.IsNotTuner=table[i]	i=i+1
	Card.IsOnField=table[i]	i=i+1
	Card.IsPosition=table[i]	i=i+1
	Card.IsPreviousLocation=table[i]	i=i+1
	Card.IsPreviousPosition=table[i]	i=i+1
	Card.IsPreviousSetCard=table[i]	i=i+1
	Card.IsPublic=table[i]	i=i+1
	Card.IsRace=table[i]	i=i+1
	Card.IsRank=table[i]	i=i+1
	Card.IsRankAbove=table[i]	i=i+1
	Card.IsRankBelow=table[i]	i=i+1
	Card.IsReason=table[i]	i=i+1
	Card.IsRelateToBattle=table[i]	i=i+1
	Card.IsRelateToCard=table[i]	i=i+1
	Card.IsRelateToChain=table[i]	i=i+1
	Card.IsRelateToEffect=table[i]	i=i+1
	Card.IsReleasable=table[i]	i=i+1
	Card.IsReleasableByEffect=table[i]	i=i+1
	Card.IsRitualType=table[i]	i=i+1
	Card.IsSetCard=table[i]	i=i+1
	Card.IsSpecialSummonable=table[i]	i=i+1
	Card.IsSSetable=table[i]	i=i+1
	Card.IsStatus=table[i]	i=i+1
	Card.IsSummonable=table[i]	i=i+1
	Card.IsSummonableCard=table[i]	i=i+1
	Card.IsSummonType=table[i]	i=i+1
	Card.IsSynchroSummonable=table[i]	i=i+1
	Card.IsSynchroType=table[i]	i=i+1
	Card.IsType=table[i]	i=i+1
	Card.IsXyzLevel=table[i]	i=i+1
	Card.IsXyzSummonable=table[i]	i=i+1
	Card.IsXyzSummonableByRose=table[i]	i=i+1
	Card.IsXyzType=table[i]	i=i+1
end
