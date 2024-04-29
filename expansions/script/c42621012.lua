--学园孤岛 佐仓慈
local cm,m=GetID()

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--release
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_RELEASE)
    e0:SetRange(0x03)
    e0:SetCountLimit(1,m)
    e0:SetCondition(cm.mvcon)
	e0:SetOperation(cm.mvop)
	e0:SetValue(m)
	c:RegisterEffect(e0)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(0x200)
	e2:SetTargetRange(0x200,0x200)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.retg)
	e4:SetOperation(cm.reop)
	c:RegisterEffect(e4)
end

function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chdck=nil
	if c:IsLocation(0x02) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,0x03,0,1,c,m) then chdck=c end
    local lpck=Duel.GetLocationCount(tp,0x08,tp,0x1,0x11)>0 or Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x11)>0
    local rck=eg:IsExists(Card.IsPreviousLocation,1,nil,0x200)
	local cck=(not c:IsForbidden()) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x02,0,1,chdck) and lpck
    local pck=(Duel.GetFlagEffect(tp,m+1)==0 and e:GetValue()==m) or Duel.GetFlagEffectLabel(tp,m+1)==e:GetValue()+1
	return rck and cck and pck
end

function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local c=e:GetHandler()
		local lpck0=Duel.GetLocationCount(tp,0x08,tp,0x1,0x11)>0
		local lpck1=Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x11)>0
		local chdck=nil
		if c:IsLocation(0x02) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,0x03,0,1,c,m) then chdck=c end
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0x02,0,1,1,chdck)
		if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) then
			local g,gc=Duel.GetMatchingGroup(Card.IsCode,tp,0x03,0,nil,m),nil
			if #g>0 then
				if #g==1 then
					gc=g:GetFirst()
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
					gc=g:Select(tp,1,1,nil):GetFirst()
				end
			end
			if gc then
				lpck0=Duel.GetLocationCount(tp,0x08,tp,0x1,0x01)>0 or Duel.GetLocationCount(tp,0x08,tp,0x1,0x10)>0
				lpck1=Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x01)>0 or Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x10)>0
				local lpck
				if lpck0 and lpck1 then
					lpck=math.abs(Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))-tp)
				else
					if lpck0 then
						lpck=tp
					else
						lpck=1-tp
					end
				end
				Duel.MoveToField(gc,tp,lpck,0x200,POS_FACEUP,true)
			end
		end
	else
		if Duel.GetFlagEffect(0,m)==0 then
			Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1,42621200)
		end
		local previousm=Duel.GetFlagEffectLabel(0,m)
		if Duel.GetFlagEffect(tp,m+1)==0 then
			Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1,previousm)
		end
		local e1=e:Clone()
		e1:SetCountLimit(1,previousm)
		e1:SetValue(previousm)
		e1:SetReset(RESET_PHASE+PHASE_END)
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,m)
		for tc in aux.Next(g) do
			tc:RegisterEffect(e1)
		end
		Duel.SetFlagEffectLabel(0,m,previousm+1)
		Duel.SetFlagEffectLabel(tp,m+1,previousm+1)
	end
end

function cm.tgfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0x01,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.RegisterFlagEffect(tp,m,0,0,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAIN_SOLVING)
			e3:SetCondition(cm.negcon)
			e3:SetOperation(cm.negop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.ChangeTargetCard(ev,Group.CreateGroup())
	Duel.ChangeChainOperation(ev,cm.repop)
	e:Reset()
	Duel.ResetFlagEffect(tp,m)
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end

function cm.tgrfilter(c)
    return c:IsAbleToHand() and c:IsFacedown()
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0x200,0x200,1,nil) or Duel.IsExistingMatchingCard(cm.tgrfilter,tp,0x08,0x08,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,PLAYER_ALL,0x208)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,0x08,0x08,nil)
    local b1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0x200,0x200,1,nil)
    local b2=#g>0
    if b1 or b2 then
        if b1 and (not b2 or Duel.SelectYesNo(m,3)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0x200,0x200,1,1,nil)
            if #hg>0 then
                Duel.HintSelection(hg)
                Duel.SendtoHand(hg,tp,REASON_EFFECT)
                if hg:GetFirst():IsLocation(0x02) then
                    Duel.ConfirmCards(1-tp,hg)
                end
            end
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            g=g:Select(tp,1,math.min(#g,4),nil)
            if #g>0 then
                Duel.HintSelection(g)
                Duel.SendtoHand(g,tp,REASON_EFFECT)
            end
        end
    end
end