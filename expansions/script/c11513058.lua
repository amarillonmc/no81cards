--闪刀姬 堕翼
function c11513058.initial_effect(c)
	c:SetSPSummonOnce(11513058)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c11513058.lcheck)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)	
	--to hand and tg 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,11513058) 
	e2:SetCost(c11513058.thtcost)
	e2:SetTarget(c11513058.thttg) 
	e2:SetOperation(c11513058.thtop) 
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c11513058.indcon)
	e2:SetOperation(c11513058.indop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(11513058,ACTIVITY_SPSUMMON,c11513058.counterfilter)
end
function c11513058.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsSetCard(0x1115)
end
function c11513058.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1115)
end
function c11513058.thtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11513058,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11513058.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c11513058.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1115)
end  
function c11513058.tgfil(c,e,tp) 
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c11513058.thfil,tp,LOCATION_DECK,0,1,nil,c)
end  
function c11513058.thfil(c,sc) 
	return c:IsAbleToHand() and c:IsSetCard(0x115) and not c:IsCode(sc:GetCode()) 
end 
function c11513058.thttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513058.tgfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11513058.thtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c11513058.tgfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp):GetFirst() 
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then 
		local g=Duel.GetMatchingGroup(c11513058.thfil,tp,LOCATION_DECK,0,nil,tc) 
		if g:GetCount()>0 then 
			local sg=g:Select(tp,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,sg)   
		end 
	end  
end 
function c11513058.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c11513058.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end 








