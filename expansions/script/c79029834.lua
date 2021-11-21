--幻想鸣奏 乡间村庄
function c79029834.initial_effect(c)
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c79029834.efilter)
	c:RegisterEffect(e1)
	--draw 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79029834.drcon)
	e2:SetOperation(c79029834.drop)
	c:RegisterEffect(e2)  
end
function c79029834.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsHasCategory(CATEGORY_TOKEN)
end
function c79029834.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==e:GetHandler():GetOwner() and eg:IsExists(Card.IsCode,1,nil,79029825) and Duel.IsPlayerCanDraw(e:GetHandler():GetOwner(),1)
end
function c79029834.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetOwner()
	if Duel.SelectYesNo(p,aux.Stringid(79029834,0)) then 
	Duel.Draw(p,1,REASON_EFFECT)
	end
end



