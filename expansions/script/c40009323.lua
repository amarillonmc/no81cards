--二天苍翼 青天·苍天
function c40009323.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c40009323.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST) 

	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009033,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,40009323)
	e1:SetCost(c40009323.descost)
	e1:SetTarget(c40009323.gytg)
	e1:SetOperation(c40009323.gyop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009033,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c40009033.eqtg)
	e2:SetOperation(c40009033.eqop)
	c:RegisterEffect(e2) 
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)   
end
function c40009323.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function c40009033.eqfilter(c,tp)
	return  (c:IsSetCard(0xf13) and c:IsType(TYPE_QUICKPLAY)) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c40009033.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009033.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40009033.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>=2 then
			g=Duel.SelectMatchingCard(tp,c40009033.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,2,tp)
		else
			g=Duel.SelectMatchingCard(tp,c40009033.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,ft,tp)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,true,true)
		--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(c40009033.eqlimit)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	--local tc=g:GetFirst()
	--while tc do
		--Duel.Equip(tp,tc,c,false,true)
		--local e1=Effect.CreateEffect(c)
		--e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	   -- e1:SetType(EFFECT_TYPE_SINGLE)
	   -- e1:SetCode(EFFECT_EQUIP_LIMIT)
	   -- e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	   -- e1:SetValue(c40009033.eqlimit)
	  --  tc:RegisterEffect(e1)
	  --  tc=g:GetNext()
   -- end
		Duel.EquipComplete()
	end
end
function c40009033.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c40009323.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c40009323.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009323.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if Duel.IsExistingMatchingCard(c40009323.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c40009323.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c40009323.tgfilter(c,tp)
	return Duel.IsExistingMatchingCard(c40009323.gyfilter,tp,0,LOCATION_ONFIELD,1,nil,c:GetColumnGroup()) and c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c40009323.gyfilter(c,g)
	return g:IsContains(c) 
end
function c40009323.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009323.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c40009323.gyop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.SelectMatchingCard(tp,c40009323.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	if pg:GetCount()==0 then return end
	local g=Duel.GetMatchingGroup(c40009323.gyfilter,tp,0,LOCATION_ONFIELD,nil,pg:GetFirst():GetColumnGroup())
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	   Duel.BreakEffect()
	   local tct=3
	   if Duel.GetTurnPlayer()~=tp then tct=2
	   elseif Duel.GetCurrentPhase()==PHASE_END then tct=3 end
	   Duel.GetControl(pg,tp,PHASE_END,tct)
	end
end