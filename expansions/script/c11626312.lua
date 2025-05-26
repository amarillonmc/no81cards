--隐匿虫 蜘蛛
local m=11626312
local cm=_G["c"..m]
function c11626312.initial_effect(c)
	--RELEASE
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RELEASE) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m) 
	e1:SetCondition(cm.htdcon) 
	e1:SetCost(cm.htdcost)
	e1:SetTarget(cm.htdtg) 
	e1:SetOperation(cm.htdop) 
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(cm.descon)  
	e2:SetTarget(cm.destg) 
	e2:SetOperation(cm.desop) 
	c:RegisterEffect(e2) 
	--buff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(cm.hxtgecon)
	e4:SetOperation(cm.hxtgeop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetRange(LOCATION_DECK)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(cm.damval)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.indtg)
	e3:SetOperation(cm.indop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter) 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function cm.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
--01
function cm.htdcon(e,tp,eg,ep,ev,re,r,rp) 
	local p=e:GetHandler():GetOwner()
	return  tp==p  
end 
function cm.htdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return  Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end 
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_INSECT)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT) 
end
--
function cm.htdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.hsrfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
end 
function cm.hsrfil(c) 
	return c:IsReleasableByEffect() and c:IsType(TYPE_MONSTER) 
end 
function cm.htdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if (not c:IsRelateToEffect(e)) or (not c:IsLocation(LOCATION_HAND)) then return end  
	Duel.SendtoDeck(c,1-tp,1,REASON_EFFECT)  
	if not c:IsLocation(LOCATION_DECK) then return end 
	Duel.ShuffleDeck(1-tp) 
	c:ReverseInDeck() 
	local dg=Duel.SelectMatchingCard(tp,cm.hsrfil,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.HintSelection(dg)
	Duel.Release(dg,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT) 
end
function cm.hxtgecon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(cm.remfilter,1,nil) and eg:IsExists(Card.IsControler,1,nil,tp) and e:GetHandler():IsFaceup()
end 
function cm.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.pbfil(c) 
	return not c:IsPublic() and c:IsAbleToDeck() and not c:IsSetCard(0x3220)
end 
function cm.hxtgeop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if eg:IsExists(Card.IsControler,1,nil,tp) then 
		Duel.Hint(HINT_CARD,0,m) 
		Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end
function cm.damval(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 and re and e:GetHandler():IsFaceup() then
		local rc=re:GetHandler()
		if not rc:IsSetCard(0x3220) then
			return 100
			end
	end
	return val
end
--02
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
end 
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
--03
--fex
function cm.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end 
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(cm.fuslimit)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e6)
	end
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end