--十四之石
function c71201916.initial_effect(c)
	aux.AddCodeList(c,71201916)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71201916,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e1:SetCountLimit(1,71201916)
	e1:SetTarget(c71201916.target)
	e1:SetOperation(c71201916.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1000) 
	e2:SetCondition(c71201916.xcon)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1) 
	e2:SetCondition(c71201916.xcon)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1) 
	e3:SetCondition(c71201916.xcon) 
	e3:SetTarget(c71201916.datg) 
	e3:SetOperation(c71201916.daop)
	c:RegisterEffect(e3)
end
function c71201916.ctfil(c) 
	return aux.IsCodeListed(c,71201916) and c:IsAbleToGraveAsCost()   
end
function c71201916.espfil(c,e,tp,g) 
	return c:IsCode(71201910) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0  
end 
function c71201916.ctgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,g:GetCount(),nil) and Duel.IsExistingMatchingCard(c71201916.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)  
end 
function c71201916.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c71201916.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c71201916.ctgck,1,99,e,tp) end 
	local sg=g:SelectSubGroup(tp,c71201916.ctgck,false,1,99,e,tp) 
	e:SetLabel(Duel.SendtoGrave(sg,REASON_COST)) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,sg:GetCount(),1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71201916.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if x>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,x,nil) then 
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,x,x,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c71201916.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg) then 
			local tc=Duel.SelectMatchingCard(tp,c71201916.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg):GetFirst() 
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
			tc:CompleteProcedure() 
			if c:IsRelateToEffect(e) then 
				c:CancelToGrave()
				Duel.Overlay(tc,c) 
			end 
		end  
	end 
end
function c71201916.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(71201910) 
end 
function c71201916.datg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c71201916.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Damage(p,d,REASON_EFFECT) 
end 




