--云磁机灵 罗姆与拉姆
function c11113170.initial_effect(c)
	c:SetSPSummonOnce(11113170)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11113170.linkcon)
	e1:SetOperation(c11113170.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--search or draw or handes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11113170.condition)
	e2:SetTarget(c11113170.target)
	e2:SetOperation(c11113170.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c11113170.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c11113170.sprfilter(c,sc)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeLinkMaterial(sc)
end
function c11113170.linkfilter1(c,tp,g,sc)
    local cd=c:GetCode()
	return g:IsExists(c11113170.linkfilter2,1,c,tp,c,sc,cd)
end
function c11113170.linkfilter2(c,tp,mc,sc,cd)
	local sg=Group.FromCards(c,mc)
	return c:IsCode(cd) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c11113170.linkfilter3(c,tp,g,sc)
	return c:IsLocation(LOCATION_MZONE) and g:IsExists(c11113170.linkfilter4,1,c,tp,c,sc)
end
function c11113170.linkfilter4(c,tp,mc,sc)
	local sg=Group.FromCards(c,mc)
	return c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c11113170.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11113170.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	return g:IsExists(c11113170.linkfilter1,1,nil,tp,g,c) or g:IsExists(c11113170.linkfilter3,1,nil,tp,g,c)
end
function c11113170.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c11113170.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	if not g:IsExists(c11113170.linkfilter1,1,nil,tp,g,c) then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g1=g:FilterSelect(tp,c11113170.linkfilter3,1,1,nil,tp,g,c)
		local mc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g2=g:FilterSelect(tp,c11113170.linkfilter4,1,1,mc,tp,mc,c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
	elseif not g:IsExists(c11113170.linkfilter3,1,nil,tp,g,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g1=g:FilterSelect(tp,c11113170.linkfilter1,1,1,nil,tp,g,c)
		local mc=g1:GetFirst()
		local cd=mc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g2=g:FilterSelect(tp,c11113170.linkfilter2,1,1,mc,tp,mc,c,cd)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
	else
	    local cg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	    if g:IsExists(c11113170.linkfilter1,1,nil,tp,cg,c) and Duel.SelectYesNo(tp,aux.Stringid(11113170,0)) then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g1=g:FilterSelect(tp,c11113170.linkfilter1,1,1,nil,tp,g,c)
			local mc=g1:GetFirst()
			if mc:IsLocation(LOCATION_MZONE) then
			    local sg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				g:Sub(sg)
			end
			local cd=mc:GetCode()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g2=g:FilterSelect(tp,c11113170.linkfilter2,1,1,mc,tp,mc,c,cd)
			g1:Merge(g2)
			c:SetMaterial(g1)
			Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		    local g1=g:FilterSelect(tp,c11113170.linkfilter3,1,1,nil,tp,g,c)
			local mc=g1:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g2=g:FilterSelect(tp,c11113170.linkfilter4,1,1,mc,tp,mc,c)
			g1:Merge(g2)
			c:SetMaterial(g1)
			Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
		end
	end
end
function c11113170.mfilter1(c,g)
    local cd=c:GetCode()
	return g:IsExists(c11113170.mfilter2,1,c,cd)
end
function c11113170.mfilter2(c,cd)
	return c:IsCode(cd)
end
function c11113170.valcheck(e,c)
	local g=c:GetMaterial()
	if not g:IsExists(c11113170.mfilter1,1,nil,g) or g:GetCount()~=2 then return end
	local ct=0
	if g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>1 then
	    ct=1
	elseif g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>1 then
	    ct=2
	else
	    local lv=g:GetSum(Card.GetLevel)
	    ct=10+lv
	end
	e:GetLabelObject():SetLabel(ct)
end
function c11113170.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11113170.thfilter(c,ct)
	return c:GetLevel()==ct-10 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11113170.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetLabel()
	if chk==0 then
	    local b1=Duel.IsPlayerCanDraw(tp,1) and ct==1
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and ct==2
		local b3=Duel.IsExistingMatchingCard(c11113170.thfilter,tp,LOCATION_DECK,0,1,nil,ct) and ct>10
		return b1 or b2 or b3
	end
	if ct==1 then
	    e:SetCategory(CATEGORY_DRAW)
	    Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif ct==2 then
	    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
	else
	    e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c11113170.operation(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
	if ct==1 then 
	    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif ct==2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	else
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11113170.thfilter,tp,LOCATION_DECK,0,1,1,nil,ct)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
    end	
end