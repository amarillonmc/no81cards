--Identi-FAIZ
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--Def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
 --equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.spcost)
	e5:SetTarget(s.tg2)
	e5:SetOperation(s.op2)
	c:RegisterEffect(e5)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(s.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function s.filter(c)
	return c:IsFaceup() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return  Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then   
		Duel.Equip(tp,c,tc) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)	 
	else
		c:CancelToGrave(false)
	end  
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(id,0))
end
function s.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c
		or c:IsControler(e:GetHandlerPlayer()) 
end
--
function s.efilter(e,re)
	if Duel.GetCurrentPhase()==PHASE_MAIN2 then return false end
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsReleasable() end
	Duel.Release(ec,REASON_COST)
end
function s.spfilter(c,e,tp,ec)
	local ep=c:GetControler()
	return  c:IsCanBeSpecialSummoned(e,0,ep,false,false,POS_FACEUP) and Duel.GetMZoneCount(ep,ec)>0 and Duel.IsExistingMatchingCard(s.refilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function s.refilter(c,ec) 
	return  c:GetAttribute()==ec:GetAttribute() or c:GetRace()==ec:GetRace()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec  
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,ec)  
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spfilter2(c,e)
	local ep=c:GetControler()
	return  c:IsCanBeSpecialSummoned(e,0,ep,false,false,POS_FACEUP) and Duel.GetMZoneCount(ep,nil)>0  and Duel.IsExistingMatchingCard(s.refilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function s.refilter1(c,ec) 
	return   c:GetRace()==ec:GetRace()
end
function s.refilter2(c,ec) 
	return  c:GetAttribute()==ec:GetAttribute() 
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local ep=tc:GetControler()
		Duel.SpecialSummon(tc,0,tp,ep,false,false,POS_FACEUP)
		local s1=Duel.IsExistingMatchingCard(s.refilter1,tp,0,LOCATION_MZONE,1,nil,tc)
		local s2=Duel.IsExistingMatchingCard(s.refilter2,tp,0,LOCATION_MZONE,1,nil,tc)
		 if s1 and (not s2 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)==0)) then
			local rg=Duel.GetMatchingGroup(s.refilter1,tp,0,LOCATION_MZONE,nil,tc)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		else
			local rg=Duel.GetMatchingGroup(s.refilter2,tp,0,LOCATION_MZONE,nil,tc)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end



