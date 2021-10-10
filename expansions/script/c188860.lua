--界限突破·刘备
function c188860.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,7)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188860,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,188860)
	e2:SetTarget(c188860.xtg)
	e2:SetOperation(c188860.xop)
	c:RegisterEffect(e2)
end
function c188860.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c188860.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c188860.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c188860.xfilter,tp,LOCATION_MZONE,0,1,c)
		and c:IsCanOverlay() and mg:GetCount()>0 end
	Debug.Message("施仁布泽，乃我大汉立国之本")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c188860.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c188860.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	local tc=Duel.GetFirstTarget()
	e:SetLabel(0)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=mg:Select(tp,1,63,nil)
		e:SetLabel(sg:GetCount())
		Duel.Overlay(tc,sg)
	end
	if e:GetLabel()>=2 and Duel.SelectYesNo(tp,aux.Stringid(188860,5)) then
		local bg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local b1=bg:GetCount()>0 and c:IsPosition(POS_FACEUP_ATTACK)
		local b2=true
		local b3=true
		local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local b4=dg:GetCount()>0
		local op=0
		if not b1 and not b4 then op=Duel.SelectOption(tp,aux.Stringid(188860,3),aux.Stringid(188860,4))+2
		elseif not b1 and b4 then op=Duel.SelectOption(tp,aux.Stringid(188860,2),aux.Stringid(188860,3),aux.Stringid(188860,4))+1
		elseif b1 and not b4 then op=Duel.SelectOption(tp,aux.Stringid(188860,1),aux.Stringid(188860,2),aux.Stringid(188860,3))
		else op=Duel.SelectOption(tp,aux.Stringid(188860,1),aux.Stringid(188860,2),aux.Stringid(188860,3),aux.Stringid(188860,4)) end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=bg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.CalculateDamage(c,sg:GetFirst(),true)
		elseif op==1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_BATTLE_TARGET)
			e1:SetOperation(c188860.disop)
			Duel.RegisterEffect(e1,tp)
		elseif op==2 then
			Duel.Recover(tp,3000,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:GetFirst():RegisterEffect(e1)
		end
	end
end
function c188860.disop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d:IsControler(tp) and d:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(188860,6)) then
		Duel.Hint(HINT_CARD,0,188860)
		Duel.NegateAttack()
		e:Reset()
	end
end

