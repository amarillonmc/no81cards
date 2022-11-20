--誓约女孩 蒂法
function c10113024.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113024,3))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c10113024.cost)
	e1:SetTarget(c10113024.target)
	e1:SetOperation(c10113024.operation)
	c:RegisterEffect(e1)
	if not Tifa then
	   Tifa={}
	end
end
function c10113024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)~=0 then
	   e:SetLabelObject(g:GetFirst())
	end
end
function c10113024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then 
	Tifa[0]=0
	Tifa[1]=0
	Tifa[2]=0   
	Tifa[3]=0   
	return true 
   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op1,op2,tc=0,0,e:GetLabelObject()
	if c:IsType(TYPE_TUNER) then
	   op1=Duel.SelectOption(tp,aux.Stringid(10113024,1),aux.Stringid(10113024,2))+2
	else
	   op1=Duel.SelectOption(tp,aux.Stringid(10113024,0),aux.Stringid(10113024,1),aux.Stringid(10113024,2))+1
	end
	Tifa[0]=op1
	if bit.band(tc:GetType(),0x40002)==0x40002 and Duel.SelectYesNo(tp,aux.Stringid(10113024,4)) then
	   if op1==1 then
		  op2=Duel.SelectOption(tp,aux.Stringid(10113024,1),aux.Stringid(10113024,2))+1
	   else
		  if c:IsType(TYPE_TUNER) then
			 if op1==2 then
				op2=Duel.SelectOption(tp,aux.Stringid(10113024,2))+3
			 elseif op1==3 then
				op2=Duel.SelectOption(tp,aux.Stringid(10113024,1))+2
			 end
		  else
			 if op1==2 then
				op2=Duel.SelectOption(tp,aux.Stringid(10113024,0),aux.Stringid(10113024,2))+1
				if op2==2 then
				   op2=3
				end
			 elseif op1==3 then
				op2=Duel.SelectOption(tp,aux.Stringid(10113024,0),aux.Stringid(10113024,1))+1
			 end
		  end
	   end
	   Tifa[1]=op2
	end
	if op1==2 or op2==2 then
	   local t={}
	   local i=1
	   local p=1
	   local lv=c:GetLevel()
	   for i=1,8 do
		   if lv~=i then t[p]=i p=p+1 end
	   end
	   t[p]=nil
	   Duel.Hint(HINT_SELECTMSG,tp,567)
	   Tifa[2]=Duel.AnnounceNumber(tp,table.unpack(t))
	end
	if op1==3 or op2==3 then
	   Duel.Hint(HINT_SELECTMSG,tp,562)
	   Tifa[3]=Duel.AnnounceAttribute(tp,1,0xff-c:GetAttribute())
	end
end
function c10113024.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	 if (Tifa[0]==1 or Tifa[1]==1) and not c:IsType(TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		c:RegisterEffect(e1)
	 end
	 if Tifa[0]==2 or Tifa[1]==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(Tifa[2])
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	 end
	 if Tifa[0]==3 or Tifa[1]==3 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(Tifa[3])
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	 end
end