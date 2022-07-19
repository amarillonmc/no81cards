--方舟骑士-临光·耀骑士
c115043.named_with_Arknight=1
function c115043.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--change effect 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAIN_SOLVING) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c115043.cecon) 
	e1:SetOperation(c115043.ceop) 
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c115043.indcon)
	e2:SetValue(c115043.indct)
	c:RegisterEffect(e2)
	--SpecialSummon P 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,315043) 
	e3:SetCondition(c115043.pspcon)
	e3:SetTarget(c115043.psptg) 
	e3:SetOperation(c115043.pspop) 
	c:RegisterEffect(e3)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c115043.matcon)
	e5:SetOperation(c115043.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c115043.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function c115043.cecon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	return c:GetFlagEffect(115043)~=0 and c:GetFlagEffect(215043)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,115046,nil,TYPES_TOKEN_MONSTER,0,2000,6,RACE_WARRIOR,ATTRIBUTE_LIGHT)
end 
function c115043.ceop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:GetFlagEffect(215043)==0 and Duel.SelectYesNo(tp,aux.Stringid(115043,0)) then  
	Duel.Hint(HINT_CARD,0,115043)
	c:RegisterFlagEffect(215043,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c115043.repop)   
	end 
end 
function c115043.indcon(e,tp,eg,ep,ev,re,r,rp)   
	return e:GetHandler():GetFlagEffect(115043)~=0 
end  
function c115043.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 4
	else return 0 end
end
function c115043.repop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,115046)
	Duel.SpecialSummon(token,0,1-tp,tp,false,false,POS_FACEUP)   
end
function c115043.pspcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) 
end   
function c115043.gthfil(c) 
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) 
end 
function c115043.pgck(g) 
	return g:FilterCount(Card.IsCode,nil,115045)==1 and g:FilterCount(c115043.gthfil,nil)==1	 
end 
function c115043.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local cg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler()) 
	if chk==0 then return cg:CheckSubGroup(c115043.pgck,2,2) end 
	local dg=Group.FromCards(sc,e:GetHandler())
	Duel.SetTargetCard(dg) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,2,0,0) 
end 
function c115043.pthfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c115043.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local cg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)==2 and Duel.Destroy(g,REASON_EFFECT)==2 and cg:CheckSubGroup(c115043.pgck,2,2) then 
	local sg=cg:SelectSubGroup(tp,c115043.pgck,false,2,2)
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end 
end 
function c115043.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c115043.mfilter(c)
	return c:IsOriginalCodeRule(115039)
end
function c115043.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(115043,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(115043,1))
end
function c115043.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetCount()>0 and g:IsExists(c115043.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end



