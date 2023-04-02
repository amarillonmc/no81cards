--星遗物的源起 
function c11513040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11513040) 
	e1:SetTarget(c11513040.actg) 
	e1:SetOperation(c11513040.acop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,21513040) 
	e2:SetCost(c11513040.spcost)
	e2:SetTarget(c11513040.sptg) 
	e2:SetOperation(c11513040.spop) 
	c:RegisterEffect(e2) 
	--to deck 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCountLimit(1,31513040)  
	e3:SetCondition(c11513040.tdcon) 
	e3:SetOperation(c11513040.tdop) 
	c:RegisterEffect(e3) 
	--cannot to deck 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetCode(EFFECT_CANNOT_TO_DECK) 
	e4:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_SZONE) end)
	c:RegisterEffect(e4) 
	--xx
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_MOVE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c11513040.adop)
	c:RegisterEffect(e5)
end 
function c11513040.atgfil(c) 
	return c:IsAbleToRemove() and c:IsSetCard(0x10c,0x116,0x11b,0xfd,0xfe,0x104) 
end 
function c11513040.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513040.atgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c11513040.athfil(c) 
	return c:IsAbleToHand() and c:IsCode(17469113) 
end 
function c11513040.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513040.atgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local rg=g:Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
		if Duel.IsExistingMatchingCard(c11513040.athfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513040,0)) then 
		local sg=Duel.SelectMatchingCard(tp,c11513040.athfil,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end 
function c11513040.spcfil(c) 
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() 
end 
function c11513040.spcgck(g,tp) 
	return g:FilterCount(Card.IsCode,nil,57282724)==1 
	   and g:FilterCount(Card.IsCode,nil,21887175)==1 
	   and Duel.GetMZoneCount(tp,g)>0 
end  
function c11513040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11513040.spcfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil) 
	if chk==0 then return g:CheckSubGroup(c11513040.spcgck,2,2,tp) end
	local sg=g:SelectSubGroup(tp,c11513040.spcgck,false,2,2,tp) 
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end 
function c11513040.spfil(c,e,tp) 
	return not c:IsPublic() and c:IsCode(17469113)  
end 
function c11513040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513040.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end 
function c11513040.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513040.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		sc:RegisterFlagEffect(11513040,0,0,EFFECT_FLAG_CLIENT_HINT,0,aux.Stringid(11513040,1)) 
		Duel.ConfirmCards(1-tp,sc) 
		if sc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) then 
		Duel.BreakEffect()  
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP) 
		end 
	end 
end 
function c11513040.dckfil(c) 
	return c:IsCode(17469113) and c:IsFaceup() 
end 
function c11513040.tdfil(c) 
	return c:IsAbleToDeck() and not c:IsCode(17469113) 
end 
function c11513040.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c11513040.dckfil,tp,LOCATION_MZONE,0,1,nil) 
end 
function c11513040.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11513040.tdfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil) 
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetChainLimit(c11513040.chlimit)
end
function c11513040.chlimit(e,ep,tp)
	return tp==ep
end
function c11513040.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513040.tdfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil) 
	if g:GetCount()>0 then  
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 
function c11513040.filsn(c)
	return c:IsOriginalCodeRule(17469113) and not c:GetFlagEffectLabel(13713040)
end
function c11513040.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c11513040.filsn,tp,0xff,0xff,c)
	local nc=ng:GetFirst()
	while nc do
		nc:RegisterFlagEffect(13713040,0,0,1)
		nc:ReplaceEffect(nc:GetOriginalCodeRule(),0)
	nc=ng:GetNext()
	end
end
if not aux.a_vida_sp_chk then
	aux.a_vida_sp_chk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect
		local b=ob or false
		if not (c:IsOriginalCodeRule(17469113))
			or not (ie:IsHasType(EFFECT_TYPE_SINGLE) and bit.band(ie:GetCode(),EFFECT_SPSUMMON_COST)==EFFECT_SPSUMMON_COST) then
			return _rge(c,ie,b)
		end
		local n1=_rge(c,ie,b) 
		if ie:GetCondition() then 
			local con=ie:GetCondition()
			ie:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():GetFlagEffect(11513040)==0 and con(e,tp,eg,ep,ev,re,r,rp) end)
		else 
			ie:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():GetFlagEffect(11513040)==0 end)  
		end  
		return n1 
	end
end






