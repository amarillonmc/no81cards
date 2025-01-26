if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=SNNM.ScreemEquips(c,0)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.regtg)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.posfilter(c,atk)
	return c:IsAttackBelow(atk) and c:IsFaceup()
end
function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetFlagEffectLabel(53762000) or 0
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,0,LOCATION_MZONE,1,nil,ct*1000) end
	e:SetLabel(ct)
	e:GetHandler():ResetFlagEffect(53762000)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,0,LOCATION_MZONE,1,1,nil,e:GetLabel()*1000)
	if #g<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetAbsoluteRange(tp,0,1)
	e1:SetValue(s.actlimit)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	tc:RegisterEffect(e1,true)
	tc:RegisterFlagEffect(0,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
function s.actlimit(e,re,tp)
	return not re:IsActiveType(TYPE_MONSTER) or re:GetHandler():GetAttack()<=e:GetHandler():GetAttack()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function s.filter(c,ec)
	return c:GetEquipTarget() and c:GetEquipTarget()==ec and c:IsReleasableByEffect()
end
function s.thfilter(c)
	return c:IsSetCard(0xc538) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler():GetEquipTarget()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct==0 then ct=1 end
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,ct,nil,e:GetHandler():GetEquipTarget())
	if sg:GetCount()>0 then
		local rct=Duel.Release(sg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,rct,rct)
		if tg and #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
