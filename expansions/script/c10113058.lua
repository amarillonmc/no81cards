--次元航母 伽乌尼斯号
function c10113058.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113058,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10113058.rmcon)
	e1:SetTarget(c10113058.rmtg)
	e1:SetOperation(c10113058.rmop)
	c:RegisterEffect(e1) 
	---effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113058,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(2)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10113058.efcost)
	e2:SetTarget(c10113058.eftg)
	e2:SetOperation(c10113058.efop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e1:SetLabelObject(e2)
end
function c10113058.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	local op=0
	if Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
	   op=Duel.SelectOption(tp,aux.Stringid(10113058,2),aux.Stringid(10113058,3))
	else
	   Duel.SelectOption(tp,aux.Stringid(10113058,2))
	   op=0
	end
	e:SetValue(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c10113058.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetValue()==0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetValue(1500)
		   c:RegisterEffect(e1)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c10113058.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=e:GetLabelObject()
	local act=e:GetLabel()
	if chk==0 then 
		if act==1 and c:GetFlagEffect(10113058)~=0 and rg:IsExists(c10113058.cfilter,1,nil) then return true
		else rg:Clear() return false 
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	local g=rg:FilterSelect(tp,c10113058.cfilter,1,1,nil)   
	Duel.SendtoGrave(g,REASON_RETURN+REASON_COST)
end
function c10113058.cfilter(c)
	return c:GetFlagEffect(10113058)~=0
end
function c10113058.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO 
end
function c10113058.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c10113058.rmop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,3,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
	   local og=Duel.GetOperatedGroup()
	   local tc=og:GetFirst()
	   while tc do
		tc:RegisterFlagEffect(10113058,RESET_EVENT+0x1fe0000,0,1)
		tc=og:GetNext()
	   end
		e:GetLabelObject():SetLabel(1)
	   if c:GetFlagEffect(10113058)==0 then
		  c:RegisterFlagEffect(10113058,RESET_EVENT+0x1fe0000,0,0)
		  e:GetLabelObject():GetLabelObject():Clear()
	   end
	   e:GetLabelObject():GetLabelObject():Merge(og)
	end
end