--闪刀姬 洛菈米亚
function c11513049.initial_effect(c)
	c:SetSPSummonOnce(11513049)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c11513049.lcheck)
	c:EnableReviveLimit() 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,11513049+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c11513049.hspcon)
	e0:SetOperation(c11513049.hspop) 
	e0:SetValue(SUMMON_TYPE_LINK) 
	c:RegisterEffect(e0) 
	--equip 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_EQUIP) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c11513049.eqtg) 
	e1:SetOperation(c11513049.eqop) 
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11513049,1))
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCost(c11513049.rmcost1) 
	e2:SetTarget(c11513049.rmtg) 
	e2:SetOperation(c11513049.rmop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetDescription(aux.Stringid(11513049,2)) 
	e3:SetCondition(c11513049.xrmcon) 
	e3:SetCost(c11513049.rmcost2) 
	c:RegisterEffect(e3) 
end
function c11513049.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1115) 
end
function c11513049.rlfil(c) 
	return c:IsAttackAbove(1500) and c:IsReleasable() and c:IsSetCard(0x1115)   
end 
function c11513049.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0  
end 
function c11513049.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c11513049.rlfil,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c11513049.rlgck,2,2,tp)  
end
function c11513049.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c11513049.rlfil,tp,LOCATION_MZONE,0,nil) 
	local sg=g:SelectSubGroup(tp,c11513049.rlgck,false,2,2,tp)
	Duel.Release(sg,REASON_COST)
end
function c11513049.eqfil(c) 
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x1115) and not c:IsForbidden()  
end 
function c11513049.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513049.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end 
function c11513049.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11513049.eqfil,tp,LOCATION_GRAVE,0,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		if not Duel.Equip(tp,tc,c) then return end 
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(e,c)
		return e:GetOwner()==c end)
		tc:RegisterEffect(e1)
		local lk=tc:GetLink()
		if lk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(lk*1500) 
			tc:RegisterEffect(e2) 
			tc:RegisterFlagEffect(13430900,RESET_EVENT+RESETS_STANDARD,0,1,lk)
		end
	end 
end 
function c11513049.xrmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3	
end 
function c11513049.rctfil1(c) 
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x1115)  
end 
function c11513049.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513049.rctfil1,tp,LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c11513049.rctfil1,tp,LOCATION_ONFIELD,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
end   
function c11513049.rctfil2(c) 
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x115) and c:IsType(TYPE_SPELL)   
end 
function c11513049.rmcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513049.rctfil2,tp,LOCATION_GRAVE,0,1,nil) end  
	local tc=Duel.SelectMatchingCard(tp,c11513049.rctfil2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
	Duel.Remove(tc,POS_FACEUP,REASON_COST) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11513049.rmlimit) 
	e1:SetLabelObject(e) 
	e1:SetLabel(tc:GetCode())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11513049.rmlimit(e,c,tp,r,re)
	return c:IsCode(e:GetLabel()) and re and re==e and r==REASON_COST 
end 
function c11513049.eqckfil(c) 
	return c:GetFlagEffectLabel(13430900)~=nil   
end 
function c11513049.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	local fck=0 
	local eqg=c:GetEquipGroup():Filter(c11513049.eqckfil,nil) 
	local ec=eqg:GetFirst() 
	while ec do 
	fck=fck+ec:GetFlagEffectLabel(13430900)
	ec=eqg:GetNext() 
	end 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and fck and c:GetFlagEffect(11513049)<fck end 
	c:RegisterFlagEffect(11513049,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c11513049.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT) 
	end 
end 









