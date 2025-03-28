--超时空武装 副武-双向导弹
local m=13257324
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_EQUIP)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.desfilter(c,f)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and f:IsExists(cm.ffilter,1,nil,c)
end
function cm.ffilter(c,ec)
	return not ec:GetColumnGroup():IsContains(c)
end
function cm.desfilter1(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function cm.ffilter2(c,g)
	return g:IsExists(cm.ffilter,1,nil,c)
end
function cm.leftfilter(c,seq)
	return c:GetSequence()>seq and c:GetSequence()<=5
end
function cm.rightfilter(c,seq)
	return c:GetSequence()<seq or c:GetSequence()==5
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local f=tama.cosmicFighters_equipGetFormation(c)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil,f)
		and f and c:GetFlagEffect(m)<f:GetCount() end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	local g=Duel.GetMatchingGroup(cm.desfilter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local fsg=f:FilterSelect(tp,cm.ffilter2,1,1,nil,g)
	if fsg:GetCount()>0 then
		local ec=fsg:GetFirst()
		local seq=ec:GetSequence()
		if seq==5 then seq=1
		elseif seq==6 then seq=3 end
		if ec:IsControler(tp) then seq=4-seq end
		local sg=Group.CreateGroup()
		local g1=g:Filter(cm.leftfilter,nil,seq)
		local g2=g:Filter(cm.rightfilter,nil,seq)
		if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=g1:Select(tp,1,1,nil)
			sg:Merge(sg1)
			if sg1:GetFirst():IsLocation(LOCATION_FZONE) then
				g2:Sub(sg1)
			end
		end
		if g2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg2=g2:Select(tp,1,1,nil)
			sg:Merge(sg2)
		end
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
