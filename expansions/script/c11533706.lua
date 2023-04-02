--影灵衣的神归镜
function c11533706.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCountLimit(1,11533706+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c11533706.cost)
	e1:SetTarget(c11533706.target)
	e1:SetOperation(c11533706.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(11533706,ACTIVITY_SPSUMMON,c11533706.counterfilter)
end
function c11533706.counterfilter(c)
	return c:IsSetCard(0xb4) 
end
function c11533706.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11533706,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11533706.splimit)
	Duel.RegisterEffect(e1,tp) 
end
function c11533706.splimit(e,c)
	return not c:IsSetCard(0xb4) 
end
function c11533706.filter(c)
	return c:IsSetCard(0xb4) and not c:IsCode(11533706) and c:IsAbleToHand()
end
function c11533706.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11533706.filter,tp,LOCATION_DECK,0,1,nil) end 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCountLimit(1) 
	e1:SetCondition(c11533706.xthcon) 
	e1:SetOperation(c11533706.xthop) 
	e1:SetLabelObject(e) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAIN_NEGATED) 
	e2:SetCountLimit(1) 
	e2:SetLabelObject(e1) 
	e2:SetCondition(c11533706.negcon) 
	e2:SetOperation(c11533706.negop) 
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_CHAIN_SOLVING) 
	e3:SetLabelObject(e) 
	e3:SetCondition(c11533706.xckcon) 
	e3:SetOperation(c11533706.xckop) 
	e3:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e3,tp)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end
function c11533706.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11533706.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c11533706.xthfil(c) 
	return c:IsAbleToHand() and not c:IsCode(11533706) and c:IsSetCard(0xb4)  
end 
function c11533706.xthcon(e,tp,eg,ep,ev,re,r,rp)   
	local flag=Duel.GetFlagEffectLabel(tp,11533706)
	return flag and flag>0 and Duel.IsExistingMatchingCard(c11533706.xthfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
end  
function c11533706.xrlfil(c) 
	return c:IsReleasable() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb4)  
end
function c11533706.xrlgck(g,tp,sc)
	return g:GetSum(Card.GetRitualLevel,sc)==sc:GetLevel() and Duel.GetMZoneCount(tp,g)>0   
end 
function c11533706.xrmfil(c) 
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb4)  
end 
function c11533706.xspfil(c,e,tp) 
	if not c:IsSetCard(0xb4) then return false end 
	if not c:IsType(TYPE_RITUAL) then return false end 
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end 
	local g=Duel.GetMatchingGroup(c11533706.xrlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local b1=g:CheckSubGroup(c11533706.xrlgck,1,99,tp,c) 
	local b2=Duel.IsExistingMatchingCard(c11533706.xrmfil,tp,LOCATION_DECK,0,1,c)
	return b1 or b2   
end 
function c11533706.xthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local flag=Duel.GetFlagEffectLabel(tp,11533706)
	if flag and flag>0 and Duel.IsExistingMatchingCard(c11533706.xthfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then 
		Duel.Hint(HINT_CARD,0,11533706) 
		local sg=Duel.SelectMatchingCard(tp,c11533706.xthfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,flag,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(c11533706.xspfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(11533706,0)) then 
			Duel.BreakEffect() 
			local tc=Duel.SelectMatchingCard(tp,c11533706.xspfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
			local g=Duel.GetMatchingGroup(c11533706.xrlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
			local b1=g:CheckSubGroup(c11533706.xrlgck,1,99,tp,tc) 
			local b2=Duel.IsExistingMatchingCard(c11533706.xrmfil,tp,LOCATION_DECK,0,1,tc)  
			local op=0 
			if b1 and b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533706,1),aux.Stringid(11533706,2))
			elseif b1 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533706,1))
			elseif b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533706,2))+1 
			end 
			local mat=Group.CreateGroup()
			if op==0 then 
				mat=g:SelectSubGroup(tp,c11533706.xrlgck,false,1,99,tp,tc) 
				Duel.ReleaseRitualMaterial(mat) 
			elseif op==1 then 
				mat=Duel.SelectMatchingCard(tp,c11533706.xrmfil,tp,LOCATION_DECK,0,1,1,tc) 
				Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) 
			end 
			tc:SetMaterial(mat) 
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		end  
	end   
end 
function c11533706.negcon(e,tp,eg,ep,ev,re,r,rp)  
	local te=e:GetLabelObject():GetLabelObject()
	return re==te   
end 
function c11533706.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local te=e:GetLabelObject() 
	te:Reset()  
end 
function c11533706.xckcon(e,tp,eg,ep,ev,re,r,rp)   
	return re:GetHandler():IsType(TYPE_RITUAL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re~=e:GetLabelObject()   
end 
function c11533706.xckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local flag=Duel.GetFlagEffectLabel(tp,11533706) 
	if flag==nil then 
		Duel.RegisterFlagEffect(tp,11533706,RESET_PHASE+PHASE_END,0,1,1) 
	else 
		Duel.SetFlagEffectLabel(tp,11533706,flag+1) 
	end  
end 




