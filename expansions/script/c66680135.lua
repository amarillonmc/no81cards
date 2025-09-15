--堕福的选灯 命途照
local s,id,o=GetID()
function s.initial_effect(c)

	-- 把这张卡从手卡丢弃才能发动，从手卡·卡组选1只「堕福」怪兽送去墓地或在自己的超量怪兽下面重叠作为超量素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	-- 这张卡被除外的场合，以自己场上1只「堕福」超量怪兽为对象才能发动，把这张卡作为那只怪兽的超量素材
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
end

-- 把这张卡从手卡丢弃才能发动，从手卡·卡组选1只「堕福」怪兽送去墓地或在自己的超量怪兽下面重叠作为超量素材
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.tgfilter(c,e,tp)
	return c:IsSetCard(0x666c) and c:IsType(TYPE_MONSTER) and (c:IsAbleToGrave() or (Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsCanOverlay()))
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanOverlay()
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if #sg>0 then
				Duel.Overlay(sg:GetFirst(),Group.FromCards(tc))
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end

function s.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

-- 这张卡被除外的场合，以自己场上1只「堕福」超量怪兽为对象才能发动，把这张卡作为那只怪兽的超量素材
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666c) and c:IsType(TYPE_XYZ)
end

function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	end
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and not tc:IsImmuneToEffect(e)
		and c:IsRelateToChain() and c:IsCanOverlay() and aux.NecroValleyFilter()(c) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
