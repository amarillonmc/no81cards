--禁制术
function c71500106.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c71500106.cost)
	e1:SetTarget(c71500106.target)
	e1:SetOperation(c71500106.activate)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCost(c71500106.thcost)
	e2:SetTarget(c71500106.thtg)
	e2:SetOperation(c71500106.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(71500106,ACTIVITY_SPSUMMON,c71500106.counterfilter)
end
function c71500106.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) 
end
function c71500106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71500106,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsCanRemoveCounter(tp,1,1,0x78f1,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x78f1,4,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) 
	return c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71500106.filter(c,e,tp)
	return true 
end 
function c71500106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=nil 
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c71500106.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function c71500106.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	::cancel::
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsOnField,nil) 
	local mg2=nil 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c71500106.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e1:SetCode(EVENT_CHAIN_END)  
		e1:SetOperation(c71500106.zdisop) 
		e1:SetReset(RESET_PHASE+PHASE_END,2)  
		Duel.RegisterEffect(e1,tp)
	end
end
function c71500106.zdisop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,71500106)
	local flag=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	local chk=0 
	Duel.Hint(HINT_ZONE,tp,flag) 
	local seq=nil  
	if flag<=32 then  
		seq=math.log(flag,2)
		chk=1 
	elseif flag<=32*256 then   
		seq=math.log(flag/256,2) 
		chk=2 
	elseif flag<=32*256*256 then   
		seq=math.log(flag/256/256,2) 
		chk=3 
	elseif flag<=32*256*256*256 then   
		seq=math.log(flag/256/256/256,2) 
		chk=4
	end  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c71500106.distg)
	e1:SetLabel(seq) 
	e1:SetValue(chk)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_DISABLE_EFFECT) 
	Duel.RegisterEffect(e2,tp)
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAIN_END)  
	e2:SetLabelObject(e1)
	e2:SetOperation(c71500106.clrop)  
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetLabel(seq) 
	e3:SetValue(chk)
	e3:SetCondition(c71500106.discon)
	e3:SetOperation(c71500106.disop) 
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_CHAIN_END)  
	e4:SetLabelObject(e3)
	e4:SetOperation(c71500106.clrop)  
	Duel.RegisterEffect(e4,tp)
end 
function c71500106.distg(e,c)
	local chk=e:GetValue()
	local seq=e:GetLabel() 
	local tp=e:GetHandlerPlayer() 
	if not ((c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) or not c:IsType(TYPE_MONSTER)) then return end 
	if chk==1 then   
		return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq 
	end  
	if chk==2 then  
		return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()==seq 
	end  
	if chk==3 then 
		if seq==5 or seq==6 then 
			if c:IsControler(tp) then 
				return math.abs(c:GetSequence(),seq)==1 and c:IsLocation(LOCATION_MZONE) 
			else 
				return c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq 
			end 
		else 
			return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq 
		end 
	end   
	if chk==4 then
		return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()==seq 
	end  
end
function c71500106.discon(e,tp,eg,ep,ev,re,r,rp) 
	local c=re:GetHandler()
	local chk=e:GetValue()
	local seq=e:GetLabel()  
	if chk==1 then   
		return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq 
	end  
	if chk==2 then 
		return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()==seq 
	end  
	if chk==3 then 
		if seq==5 or seq==6 then 
			if c:IsControler(tp) then 
				return math.abs(c:GetSequence(),seq)==1 and c:IsLocation(LOCATION_MZONE) 
			else 
				return c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq 
			end 
		else 
			return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq 
		end 
	end   
	if chk==4 then
		return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()==seq 
	end  
end
function c71500106.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c71500106.clrop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject() 
	te:Reset() 
	e:Reset()
end
function c71500106.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsCanRemoveCounter(tp,1,1,0x78f1,1,REASON_COST) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.RemoveCounter(tp,1,1,0x78f1,1,REASON_COST) 
end
function c71500106.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71500106.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71500106.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71500106.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c71500106.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c71500106.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end






