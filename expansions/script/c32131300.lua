--始源之律者 爱莉希雅
function c32131300.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c32131300.ffilter,13,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,aux.tdcfop(c)):SetCondition(c32131300.xfucon)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION end)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end)
	c:RegisterEffect(e1)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end) 
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5) 
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6) 
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end) 
	c:RegisterEffect(e6)
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) 
	e1:SetCountLimit(1,32131300)
	e1:SetTarget(c32131300.xxtg1) 
	e1:SetOperation(c32131300.xxop1) 
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,23131300)
	e2:SetTarget(c32131300.xxtg2) 
	e2:SetOperation(c32131300.xxop2) 
	c:RegisterEffect(e2)  
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTarget(c32131300.sptg) 
	e3:SetOperation(c32131300.spop)   
	c:RegisterEffect(e3)  
	if not c32131300.global_check then
		c32131300.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS) 
		local g=Group.CreateGroup() 
		g:KeepAlive()  
		ge1:SetLabelObject(g)
		ge1:SetOperation(c32131300.checkop)
		Duel.RegisterEffect(ge1,0) 
	end 
end  
c32131300.SetCard_HR_flame13=true 
function c32131300.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local g=e:GetLabelObject() 
	local tc=eg:GetFirst()
	while tc do 
	if tc.SetCard_HR_flame13 and not g:IsExists(Card.IsCode,1,nil,tc:GetCode()) then 
	g:AddCard(tc) 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),32131300,0,0,1) 
	end 
	tc=eg:GetNext()  
	end
end
function c32131300.xfucon(e) 
	return Duel.GetFlagEffect(tp,32131300)>=13 
end 
function c32131300.ffilter(c,fc,sub,mg,sg)
	return (c.SetCard_HR_flame13 and c:IsType(TYPE_MONSTER)) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) 
end
function c32131300.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c32131300.xxop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1) 
	e1:SetLabel(Duel.GetTurnCount())	
	e1:SetCondition(c32131300.axcon)  
	e1:SetOperation(c32131300.axop) 
	e1:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e1,tp) 
end 
function c32131300.axcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnCount()~=e:GetLabel()   
end 
function c32131300.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)   
end 
function c32131300.axop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)  
	local x=Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	if x>0 then 
	   Duel.Draw(1-tp,x,REASON_EFFECT) 
	   Duel.BreakEffect() 
	   if Duel.IsExistingMatchingCard(c32131300.spfil,1-tp,LOCATION_HAND,0,1,nil,e,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
	   local sg=Duel.SelectMatchingCard(1-tp,c32131300.spfil,1-tp,LOCATION_HAND,0,1,99,nil,e,1-tp) 
	   Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP) 
	   end 
	end 
end 
function c32131300.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c32131300.xxop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1) 
	e1:SetLabel(Duel.GetTurnCount())	
	e1:SetCondition(c32131300.bxcon)  
	e1:SetOperation(c32131300.bxop) 
	e1:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e1,tp)  
end 
function c32131300.bxcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnCount()~=e:GetLabel()   
end 
function c32131300.bxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)  
	local x=Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	if x>0 then 
	   Duel.Draw(tp,x,REASON_EFFECT) 
	   Duel.BreakEffect() 
	   if Duel.IsExistingMatchingCard(c32131300.spfil,tp,LOCATION_HAND,0,1,nil,e,tp)  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   local sg=Duel.SelectMatchingCard(1-tp,c32131300.spfil,tp,LOCATION_HAND,0,1,99,nil,e,tp) 
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	   end 
	end 
end 
function c32131300.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c.SetCard_HR_flame13   
end 
function c32131300.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c32131300.xspfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end  
function c32131300.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131300.xspfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 








