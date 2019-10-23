--方界劫
function c40008671.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008671+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c40008671.target)
	e1:SetOperation(c40008671.operation)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008671,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c40008671.sprcon1)
	e2:SetOperation(c40008671.sprop1)
	e2:SetValue(SUMMON_TYPE_SPECIAL)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,3775068))
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008671,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c40008671.sprcon1)
	e4:SetOperation(c40008671.sprop2)
	e4:SetValue(SUMMON_TYPE_SPECIAL)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,4998619))
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5) 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008671,1))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c40008671.sprcon3)
	e6:SetOperation(c40008671.sprop3)
	e6:SetValue(SUMMON_TYPE_SPECIAL)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsCode,77387463))
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7) 
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(40008671,1))
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetRange(LOCATION_HAND)
	e8:SetCondition(c40008671.sprcon3)
	e8:SetOperation(c40008671.sprop4)
	e8:SetValue(SUMMON_TYPE_SPECIAL)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(LOCATION_HAND,0)
	e9:SetTarget(aux.TargetBoolFunction(Card.IsCode,78509901))
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(40008671,1))
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetRange(LOCATION_HAND)
	e10:SetCondition(c40008671.sprcon5)
	e10:SetOperation(c40008671.sprop5)
	e10:SetValue(SUMMON_TYPE_SPECIAL)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTargetRange(LOCATION_HAND,0)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsCode,40392714))
	e11:SetLabelObject(e10)
	c:RegisterEffect(e11)  
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(40008671,1))
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetRange(LOCATION_HAND)
	e12:SetCondition(c40008671.sprcon5)
	e12:SetOperation(c40008671.sprop6)
	e12:SetValue(SUMMON_TYPE_SPECIAL)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e13:SetRange(LOCATION_FZONE)
	e13:SetTargetRange(LOCATION_HAND,0)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsCode,41114306))
	e13:SetLabelObject(e12)
	c:RegisterEffect(e13)  
end
function c40008671.spcfilter(c,tp)
	return ((c:IsFaceup() and c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0xe3))) and c:IsAbleToGraveAsCost()
end
function c40008671.sprcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,c)
	return g:GetCount()>=3 and ft>-3 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft and Duel.GetFlagEffect(tp,40008671)==0
end
function c40008671.sprop1(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=3 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<3 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,3-ct,3-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,3,3,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2400)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40008671.sprop2(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=3 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<3 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,3-ct,3-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,3,3,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(3000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40008671.sprcon3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,c)
	return g:GetCount()>=2 and ft>-2 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft and Duel.GetFlagEffect(tp,40008671)==0
end
function c40008671.sprop3(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=2 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<2 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,2-ct,2-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,2,2,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40008671.sprop4(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=2 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<2 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,2-ct,2-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,2,2,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40008671.sprcon5(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,c)
	return g:GetCount()>=1 and ft>-1 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft and Duel.GetFlagEffect(tp,40008671)==0
end
function c40008671.sprop5(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=1 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<1 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,1-ct,1-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,1,1,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40008671.sprop6(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c40008671.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=1 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<1 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,1-ct,1-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,1,1,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40008671.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) 
end
function c40008671.thfilter(c)
	return c:IsSetCard(0xe3) and not c:IsCode(40008671) and c:IsAbleToHand()
end
function c40008671.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008671.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c40008671.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c40008671.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c40008671.filter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=0 then
			local sg=Duel.GetMatchingGroup(c40008671.thfilter,tp,LOCATION_DECK,0,nil)
			if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40008671,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				sg=sg:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end