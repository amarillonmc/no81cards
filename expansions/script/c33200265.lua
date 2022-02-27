--龙德在田 刘玄德
function c33200265.initial_effect(c)
	c:SetUniqueOnField(1,1,33200265)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200265,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33200265)
	e1:SetTarget(c33200265.cgtg)
	e1:SetOperation(c33200265.cgop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200265,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33200266)
	e3:SetTarget(c33200265.thtg)
	e3:SetOperation(c33200265.thop)
	c:RegisterEffect(e3)
end

--e1e2
function c33200265.cgfilter(c)
	return c:IsFaceup() and c:IsCode(33200250) and c:IsAbleToChangeControler()
end
function c33200265.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200265.cgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function c33200265.cgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33200265.cgfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local fd=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if fd==0 then return end
	if fd>2 then fd=2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200265,0))
	local g=Duel.SelectMatchingCard(tp,c33200265.cgfilter,tp,LOCATION_MZONE,0,1,fd,nil)
	Duel.HintSelection(g)
	if g:GetCount()==1 then
		if Duel.GetControl(g,1-tp) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
	if g:GetCount()==2 then
		if Duel.GetControl(g,1-tp) then
			Duel.Recover(tp,1000,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--th
function c33200265.thfilter(c)
	return c:IsSetCard(0x326) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c33200265.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33200265.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local dg1=Duel.GetDecktopGroup(tp,1)
	local dgc=dg1:GetFirst()
	if dgc:IsSetCard(0x326) and dgc:IsAbleToHand() then
		Duel.SendtoHand(dgc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,dgc)
	else
		Duel.ShuffleDeck(tp)
		if Duel.SelectYesNo(tp,aux.Stringid(33200265,2)) then
			Duel.ConfirmDecktop(tp,1)
			local dg2=Duel.GetDecktopGroup(tp,1)
			local dgc=dg2:GetFirst() 
			if dgc:IsSetCard(0x326) and dgc:IsAbleToHand() then
				Duel.SendtoHand(dgc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,dgc) 
			else
				Duel.ShuffleDeck(tp)
				if Duel.SelectYesNo(tp,aux.Stringid(33200265,3)) then
					Duel.ConfirmDecktop(tp,1)
					local dg3=Duel.GetDecktopGroup(tp,1)
					local dgc=dg3:GetFirst() 
					if dgc:IsSetCard(0x326) and dgc:IsAbleToHand() then
						if Duel.SendtoHand(dgc,nil,REASON_EFFECT) then 
							Duel.ConfirmCards(1-tp,dgc) 
						else
							Duel.Damage(tp,3000,REASON_EFFECT) 
						end
					else
						Duel.ShuffleDeck(tp)
						Duel.Damage(tp,3000,REASON_EFFECT)
					end
				end
			end
		end
	end
end