--最古最强之龙 美露莘
function c11513044.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c11513044.lcheck)
	c:EnableReviveLimit()
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c11513044.lmlimit)
	c:RegisterEffect(e1)
	--extra material
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	--e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	--e1:SetRange(LOCATION_EXTRA)
	--e1:SetTargetRange(LOCATION_HAND,0)
	--e1:SetValue(c11513044.matval)
	--c:RegisterEffect(e1)
	--atk 
	--local e1=Effect.CreateEffect(c) 
	--e1:SetType(EFFECT_TYPE_SINGLE) 
	--e1:SetCode(EFFECT_SET_BASE_ATTACK) 
	--e1:SetRange(LOCATION_MZONE) 
	--e1:SetValue(function(e) 
	--local mg=e:GetHandler():GetMaterial() 
	--return mg:GetSum(Card.GetAttack) end) 
	--e1:SetCondition(function(e) 
	--return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	--c:RegisterEffect(e1)   
	--to hand 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11513044)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)  
	e1:SetCost(c11513044.thcost)
	e1:SetTarget(c11513044.thtg) 
	e1:SetOperation(c11513044.thop) 
	c:RegisterEffect(e1) 
	--rl and sp 
	--local e2=Effect.CreateEffect(c) 
	--e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON) 
	--e2:SetType(EFFECT_TYPE_IGNITION) 
	--e2:SetRange(LOCATION_MZONE) 
	--e2:SetCountLimit(1,13713044) 
	--e2:SetTarget(c11513044.rsptg) 
	--e2:SetOperation(c11513044.rspop) 
	--c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED) 
	e3:SetCountLimit(1,21513044) 
	e3:SetCondition(aux.exccon)
	e3:SetCost(c11513044.xthcost) 
	e3:SetTarget(c11513044.xxthtg) 
	e3:SetOperation(c11513044.xxthop) 
	c:RegisterEffect(e3)
	if not c11513044.global_check then
		c11513044.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c11513044.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c11513044.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do  
	local se=tc:GetReasonEffect()
	if se and se:IsActiveType(TYPE_SPELL) and not tc:IsType(TYPE_RITUAL) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),11513044,RESET_PHASE+PHASE_END,0,1) 
	end 
	tc=eg:GetNext()
	end
end
function c11513044.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function c11513044.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c11513044.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:IsType(TYPE_RITUAL),not mg or not mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) 
end
function c11513044.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11513044.splimit) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
function c11513044.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsActiveType(TYPE_SPELL) and not c:IsType(TYPE_RITUAL)
end
function c11513044.thfil1(c,e) 
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetAttack()<e:GetHandler():GetMaterial():GetSum(Card.GetBaseAttack)
end 
function c11513044.thfil2(c,sc) 
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and aux.IsCodeListed(c,sc:GetCode())
end 
function c11513044.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513044.thfil1,tp,LOCATION_DECK,0,1,nil,e) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c11513044.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513044.thfil1,tp,LOCATION_DECK,0,nil,e) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(sc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sc) 
		if Duel.IsExistingMatchingCard(c11513044.thfil2,tp,LOCATION_DECK,0,1,nil,sc) and Duel.SelectYesNo(tp,aux.Stringid(11513044,0)) then 
		local sg=Duel.SelectMatchingCard(tp,c11513044.thfil2,tp,LOCATION_DECK,0,1,1,nil,sc)
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end 
function c11513044.rspfil(c,e,tp)  
	local atk=e:GetHandler():GetBaseAttack()
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:GetAttack()<atk and Duel.GetMZoneCount(tp,e:GetHandler())>0  
end  
function c11513044.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c11513044.rspfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c11513044.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513044.rspfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)~=0 and g:GetCount()>0 then  
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		sc:SetMaterial(Group.FromCards(c)) 
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
		if sc:IsCode(11513043) then 
		local atk=e:GetHandler():GetMaterial():GetSum(Card.GetAttack) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_BASE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		sc:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_SET_BASE_DEFENSE) 
		sc:RegisterEffect(e2) 
		end   
	end 
end 
function c11513044.xctfil(c) 
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)  
end 
function c11513044.xthcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() and Duel.IsExistingMatchingCard(c11513044.xctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,c11513044.xctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end 
function c11513044.xxthfil1(c) 
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end 
function c11513044.xxthfil2(c,sc) 
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and aux.IsCodeListed(c,sc:GetCode())
end 
function c11513044.xxthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513044.xxthfil1,tp,LOCATION_DECK,0,1,nil,e) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c11513044.xxthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513044.xxthfil1,tp,LOCATION_DECK,0,nil,e) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(sc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sc) 
		if Duel.IsExistingMatchingCard(c11513044.xxthfil2,tp,LOCATION_DECK,0,1,nil,sc) and Duel.SelectYesNo(tp,aux.Stringid(11513044,0)) then 
		local sg=Duel.SelectMatchingCard(tp,c11513044.xxthfil2,tp,LOCATION_DECK,0,1,1,nil,sc)
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end 
function c11513044.xthfil(c) 
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()  
end 
function c11513044.xthgck(g) 
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SPELL)==1 
end 
function c11513044.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(c11513044.xthfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c11513044.xthgck,2,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_DECK) 
end 
function c11513044.xthop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513044.xthfil,tp,LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(c11513044.xthgck,2,2) then 
	local sg=g:SelectSubGroup(tp,c11513044.xthgck,false,2,2) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 







