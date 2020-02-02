--天使-冰结傀儡
function c33400502.initial_effect(c)
	 --atc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	  --add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c33400502.condition)
	e1:SetOperation(c33400502.counter)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c33400502.condition2)
	e2:SetTarget(c33400502.thtg2)
	e2:SetOperation(c33400502.thop2)
	c:RegisterEffect(e2)
end
function c33400502.cnfilter(c)
	return c:IsSetCard(0x6341) and c:IsFaceup()
end
function c33400502.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400502.cnfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c33400502.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:GetHandler()~=e:GetHandler() and re:GetHandler():IsCanAddCounter(0x1015,1)
end
function c33400502.counter(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if  c:IsLocation(LOCATION_ONFIELD) and re:GetHandler():IsRelateToEffect(re) then 
			c:AddCounter(0x1015,1)
		end
end

function c33400502.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return   Duel.IsCanRemoveCounter(tp,1,1,0x1015,1,REASON_COST)
	end
	local cn=Duel.GetCounter(tp,1,1,0x1015)
	local lvt={} 
	 for i=1,16 do 
	 if cn>=i then lvt[i]=i end
	 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400502,0))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,1,0x1015,sc1,REASON_COST)  
	for i=1,sc1 do 
	Duel.RegisterFlagEffect(tp,33400502,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
	end
	e:SetLabel(sc1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,0,0,0,0)
end
function c33400502.thop2(e,tp,eg,ep,ev,re,r,rp)
	local nm=e:GetLabel()
	local op={}
	local t
	local i=1
	if Duel.GetFlagEffect(tp,33430502)==0 and Duel.GetFlagEffect(tp,33400502)>=4 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) then 
	op[i]=3 
	i=i+1
	end
	if Duel.GetFlagEffect(tp,33440502)==0 and Duel.GetFlagEffect(tp,33400502)>=7 and Duel.IsExistingMatchingCard(c33400502.filter1,tp,LOCATION_ONFIELD,0,1,nil) then 
	op[i]=4 
	i=i+1
	end
	if Duel.GetFlagEffect(tp,33450502)==0 and Duel.GetFlagEffect(tp,33400502)>=10 and Duel.IsExistingMatchingCard(c33400502.filter2,tp,LOCATION_MZONE,0,1,nil) then 
	op[i]=5 
	i=i+1
	end
	if Duel.GetFlagEffect(tp,33470502)==0 and Duel.GetFlagEffect(tp,33400502)>=13 and Duel.IsExistingMatchingCard(c33400502.filter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then 
	op[i]=6
	i=i+1
	end 
	if Duel.GetFlagEffect(tp,33460502)==0 and Duel.GetFlagEffect(tp,33400502)>=16 then 
	op[i]=7
	i=i+1
	end 
	if i==1  then 
	   Duel.Recover(tp,nm*100,REASON_EFFECT)
	else 
		t=Duel.SelectOption(tp,aux.Stringid(33400502,1),aux.Stringid(33400502,2))
		if t==0 then Duel.Recover(tp,nm*100,REASON_EFFECT) 
		else 
			local j=0
			local op1
			repeat
				 if i==2 then 
				  op1=1
				 end
				 if i==3 then 
				  op1=Duel.SelectOption(tp,aux.Stringid(33400502,op[1]),aux.Stringid(33400502,op[2]))+1
				 end
				 if i==4 then 
				  op1=Duel.SelectOption(tp,aux.Stringid(33400502,op[1]),aux.Stringid(33400502,op[2]),aux.Stringid(33400502,op[3]))+1
				 end
				 if i==5 then 
				   op1=Duel.SelectOption(tp,aux.Stringid(33400502,op[1]),aux.Stringid(33400502,op[2]),aux.Stringid(33400502,op[3]),aux.Stringid(33400502,op[4]))+1
				 end
				 if i==6 then 
				   op1=Duel.SelectOption(tp,aux.Stringid(33400502,op[1]),aux.Stringid(33400502,op[2]),aux.Stringid(33400502,op[3]),aux.Stringid(33400502,op[4]),aux.Stringid(33400502,op[5]))+1
				 end
				 local xz=0
				  if op[op1]==3 then
				  local tc3=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x341)
				  local tc2=tc3:GetFirst()
				   local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCountLimit(1)
					e1:SetValue(c33400502.valcon)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc2:RegisterEffect(e1)
					Duel.RegisterFlagEffect(tp,33430502,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					if op1~=i-1 then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					i=i-1
					xz=1
				  end
				  if op[op1]==4 and xz==0 then 
				  local tc3=Duel.SelectMatchingCard(tp,c33400502.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
				  local tc2=tc3:GetFirst()
					 local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_SINGLE)
					e4:SetCode(EFFECT_IMMUNE_EFFECT)
					e4:SetValue(c33400502.efilter)
					e4:SetOwnerPlayer(tp)
					e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
					tc2:RegisterEffect(e4)
					Duel.RegisterFlagEffect(tp,33440502,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					if op1~=i-1 then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					i=i-1
					xz=1
				  end
				  if op[op1]==5 and xz==0 then 
				  local tc3=Duel.SelectMatchingCard(tp,c33400502.filter2,tp,LOCATION_MZONE,0,1,1,nil)
				   local tc2=tc3:GetFirst()
				  local nm1=Duel.GetCounter(tp,1,1,0x1015)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UPDATE_ATTACK)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetValue(200*nm1)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc2:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_UPDATE_DEFENSE)
						tc2:RegisterEffect(e2)
					 Duel.RegisterFlagEffect(tp,33450502,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					 if op1~=i-1 then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					 i=i-1
					 xz=1
				  end
				  if op[op1]==7 and xz==0 then 
					   local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1015,1)
						local tc=g:GetFirst()
						while tc do
							tc:AddCounter(0x1015,1,REASON_EFFECT)
							tc=g:GetNext()
						end
					  Duel.RegisterFlagEffect(tp,33460502,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					 if op1~=i-1 then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					 i=i-1
					 xz=1
				  end
				  if op[op1]==6 and xz==0 then 
					   local tc2=Duel.SelectMatchingCard(tp,c33400502.filter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,2,2,nil)
					   Duel.SendtoHand(tc2,nil,REASON_EFFECT) 
					   Duel.ConfirmCards(1-tp,tc2)
					  Duel.RegisterFlagEffect(tp,33470502,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					  if op1~=i-1 then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					  i=i-1
					  xz=1
				  end
			if i==1 then j=0 
			else if Duel.SelectYesNo(tp,aux.Stringid(33400502,8)) then j=1
				 else  j=0
				 end
			end  
			xz=0 
			until(j==0) 
			Duel.BreakEffect()
		end
	end
end
function c33400502.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c33400502.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c33400502.filter1(c)
	return c:IsSetCard(0x341) or c:IsSetCard(0x340)  
end
function c33400502.filter2(c)
	return c:IsType(TYPE_MONSTER)and c:IsSetCard(0x6341) or c:IsSetCard(0x3344)  
end
function c33400502.filter3(c)
	return c:IsAbleToHand()and  c:IsType(TYPE_MONSTER)and c:IsLevel(4) and (c:IsSetCard(0x6341) or c:IsSetCard(0x3344))
end