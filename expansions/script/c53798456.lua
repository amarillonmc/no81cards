local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,id-4)
	--revive limit
	c:EnableReviveLimit()
	--pendulum effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	--destroy equip and lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--equip opponent monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local tc=nil
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		tc=g:Select(1-tp,1,1,nil):GetFirst()
	else
		local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		Duel.ConfirmCards(tp,hg)
		Duel.ShuffleHand(1-tp)
	end
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		if Duel.Draw(1-tp,1,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
			local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
			if #thg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				if Duel.Destroy(c,REASON_EFFECT)>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tg=thg:Select(tp,1,1,nil)
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tg)
				end
			end
		end
	else
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function s.eqfilter1(c)
	return c:GetOriginalType()&TYPE_MONSTER>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter1,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(s.eqfilter1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		local tc=dg:GetFirst()
		local race=tc:GetOriginalRace()
		local att=tc:GetOriginalAttribute()
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetLabel(race,att)
			e1:SetCondition(s.actcon)
			e1:SetValue(s.actlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.actlimit(e,re,tp)
	local rc=re:GetHandler()
	local race,att=e:GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and (rc:GetOriginalRace()&race>0 or rc:GetOriginalAttribute()&att>0)
end
function s.eqfilter2(c)
	return c:GetFlagEffect(id)~=0
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local g=c:GetEquipGroup():Filter(s.eqfilter2,nil)
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToChangeControler()
		and g:GetCount()==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or not c:IsFaceup() then return end
	if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		if Duel.Equip(tp,tc,c) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(2500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end