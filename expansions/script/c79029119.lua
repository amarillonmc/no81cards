--乌萨斯·辅助干员-真理
function c79029119.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xa900),2)
	 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39890958,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c79029119.eqtg)
	e1:SetOperation(c79029119.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39890958,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c79029119.sptg)
	e2:SetOperation(c79029119.spop)
	c:RegisterEffect(e2)  
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(c79029119.repval)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetValue(700)
	c:RegisterEffect(e4)
	--change effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71166481,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCountLimit(1)
	e5:SetCondition(c79029119.chcon)
	e5:SetTarget(c79029119.chtg)
	e5:SetOperation(c79029119.chop)
	c:RegisterEffect(e5)
	--eqlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c79029119.eqlimit)
	c:RegisterEffect(e6)	 
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c79029119.eqlimit(e,c)
	return c:IsSetCard(0xa900) or e:GetHandler():GetEquipTarget()==c
end
function c79029119.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0xa900) and ct2==0
end
function c79029119.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79029119.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(79029119)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c79029119.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c79029119.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(79029119,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c79029119.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c79029119.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c79029119.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(79029119)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	   and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(79029119,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c79029119.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function c79029119.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c79029119.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c79029119.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c79029119.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c79029119.repop)
end
function c79029119.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(54719828,2))
		e1:SetValue(c79029119.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetDescription(aux.Stringid(54719828,3))
		e1:SetValue(c79029119.aclimit2)
	else
		e1:SetDescription(aux.Stringid(54719828,4))
		e1:SetValue(c79029119.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c79029119.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c79029119.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c79029119.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end










