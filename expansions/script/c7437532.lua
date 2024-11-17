--双天魂 形阿
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	s.Contact_Fusion_check=false
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),s.ffilter,1,true)
	s.AddContactFusionProcedure(c,aux.TRUE,LOCATION_ONFIELD,0,s.descfop(c))
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(s.rthtg)
	e5:SetOperation(s.rthop)
	c:RegisterEffect(e5)
end
function s.thfilter(c)
	return c:IsSetCard(0x14f) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.rthfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x14f) and c:IsAbleToHand()
end
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.rthfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.rthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

------------------------------Contact Fusion------------------------------------

function s.ffilter(c)
	return (not s.Contact_Fusion_check and c:IsFusionSetCard(0x14f)) or (s.Contact_Fusion_check and c:IsFusionCode(87669905))
end
--Destroy of contact fusion
function s.descfop(c)
	return  function(g)
				Duel.Destroy(g,nil,REASON_COST)
			end
end
--Contact Fusion
function s.AddContactFusionProcedure(c,filter,self_location,opponent_location,mat_operation,...)
	self_location=self_location or 0
	opponent_location=opponent_location or 0
	local operation_params={...}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.ContactFusionCondition(filter,self_location,opponent_location))
	e2:SetTarget(s.ContactFusionTarget(filter,self_location,opponent_location))
	e2:SetOperation(s.ContactFusionOperation(mat_operation,operation_params))
	c:RegisterEffect(e2)
	return e2
end
function s.ContactFusionMaterialFilter(c,fc,filter)
	return c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and (not filter or filter(c,fc))
end
function s.ContactFusionCondition(filter,self_location,opponent_location)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				s.Contact_Fusion_check=true
				local mg=Duel.GetMatchingGroup(s.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local result=c:CheckFusionMaterial(mg,nil,tp|0x200)
				s.Contact_Fusion_check=false
				return result
			end
end
function s.ContactFusionTarget(filter,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				s.Contact_Fusion_check=true
				local mg=Duel.GetMatchingGroup(s.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				s.Contact_Fusion_check=false
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function s.ContactFusionOperation(mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				mat_operation(g,table.unpack(operation_params))
				g:DeleteGroup()
			end
end
