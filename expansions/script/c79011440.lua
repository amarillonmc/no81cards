--佩恩 「漂泊浪客」 - 天道
function c79011440.initial_effect(c)
	c:SetUniqueOnField(1,0,79011440)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false) 
	c:EnableReviveLimit()
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCost(c79011440.spcost)
	e0:SetOperation(c79011440.spcop)
	c:RegisterEffect(e0)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCondition(c79011440.espcon)
	e1:SetOperation(c79011440.espop)
	c:RegisterEffect(e1) 
	--change 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,79011440) 
	e1:SetTarget(c79011440.cgtg)
	e1:SetOperation(c79011440.cgop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c79011440.thtg)
	e2:SetOperation(c79011440.thop)
	c:RegisterEffect(e2) 
	--add effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79011440)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)  
	e1:SetCondition(function(e) 
	return e:GetHandler():GetSequence()==0 end)
	c:RegisterEffect(e1)
	--pth 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c79011440.pthcon) 
	e2:SetTarget(c79011440.pthtg)
	e2:SetOperation(c79011440.pthop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(function(e,te) 
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end)
	c:RegisterEffect(e3) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_END and not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c.SetCard_Pain_PBLK end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(79011440,ACTIVITY_SUMMON,c79011440.counterfilter)
	Duel.AddCustomActivityCounter(79011440,ACTIVITY_SPSUMMON,c79011440.counterfilter)
end
c79011440.SetCard_Pain_PBLK=true 
function c79011440.counterfilter(c)
	return c.SetCard_Pain_PBLK 
end 
function c79011440.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(79011440,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(79011440,tp,ACTIVITY_SUMMON)==0 
end
function c79011440.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return not c.SetCard_Pain_PBLK end)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return not c.SetCard_Pain_PBLK end)
	Duel.RegisterEffect(e1,tp)
end
function c79011440.espcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	   and Duel.IsExistingMatchingCard(function(c) return not c:IsPublic() and c.SetCard_Pain_PBLK_Skill and c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost() end,tp,LOCATION_HAND,0,2,nil) 
	   and Duel.IsExistingMatchingCard(function(c) return c:IsCode(79011453) and c:IsAbleToHandAsCost() end,tp,LOCATION_DECK,0,1,nil)
	   and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,79011441) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,79011445) 
end
function c79011440.espop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,function(c) return not c:IsPublic() and c.SetCard_Pain_PBLK_Skill and c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost() end,tp,LOCATION_HAND,0,2,2,nil) 
	Duel.ConfirmCards(1-tp,g)  
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
	local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(79011453) and c:IsAbleToHandAsCost() end,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_COST) 
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)  
	local tc1=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_EXTRA,0,1,1,nil,79011441):GetFirst()   
	Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true,1) 
	Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)  
	local tc2=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_EXTRA,0,1,1,nil,79011445):GetFirst()   
	Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)   
	Duel.Hint(24,0,aux.Stringid(79011440,0)) 
end
function c79011440.cspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetMZoneCount(tp,e:GetHandler())>0 and c.SetCard_Pain_PBLK and Duel.IsExistingMatchingCard(c79011440.spsetfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:GetSequence()==4 
end 
function c79011440.spsetfil(c,e,tp,sc) 
	local lv=sc:GetOriginalLevel() 
	local pc=Duel.GetFieldCard(tp,LOCATION_PZONE,0) 
	if pc and pc.SetCard_Pain_PBLK and pc:GetOriginalLevel()==lv-1 then 
		lv=lv-1 
	end 
	if lv==1 then lv=7 end 
	return c.SetCard_Pain_PBLK and c:GetOriginalLevel()==lv-1  
end 
function c79011440.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c79011440.cspfil,tp,LOCATION_PZONE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end 
function c79011440.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local sc=Duel.GetFirstMatchingCard(c79011440.cspfil,tp,LOCATION_PZONE,0,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and sc and Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c79011440.spsetfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,sc) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c79011440.spsetfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)   
		Duel.MoveSequence(tc,4)
	end 
end 
function c79011440.thfilter(c)
	return aux.IsCodeListed(c,79011440) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c79011440.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79011440.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c79011440.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79011440.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79011440.pthcon(e,tp,eg,ep,ev,re,r,rp)
	return 1-tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(1-tp)>0 and e:GetHandler():GetSequence()==0
end  
function c79011440.pthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetDecktopGroup(1-tp,6)
	if chk==0 then return g:GetCount()==6 and g:IsExists(Card.IsAbleToHand,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c79011440.pthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetDecktopGroup(1-tp,6) 
	if g:GetCount()==6 then 
		Duel.ConfirmDecktop(1-tp,6) 
		local sg=g:Filter(Card.IsAbleToHand,nil):Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		Duel.SortDecktop(tp,1-tp,5) 
	end 
end
function c79011440.excon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,79011440) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
end 
function c79011440.exop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)  
end 



