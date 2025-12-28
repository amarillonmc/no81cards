--D-旅团 暗龙兽ACE
local s,id=GetID()

s.named_with_DBrigade=1
function s.DBrigade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DBrigade
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.gycon)
	c:RegisterEffect(e3)
end

function s.tfilter(c,tp)
	return s.DBrigade(c) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.tfilter,1,nil,tp)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.tfilter,nil,tp)
	if chk==0 then return tg:IsExists(Card.IsReleasable,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=tg:FilterSelect(tp,Card.IsReleasable,1,1,nil)
	Duel.Release(sg,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTarget(s.drawtg)
		e1:SetOperation(s.drawop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end

function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end

function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	local opp=1-tp
	local hc=Duel.GetFieldGroupCount(opp,LOCATION_HAND,0)
	local need=4-hc
	if need>0 then
		Duel.Draw(opp,need,REASON_EFFECT)
	end

end

function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end

function s.valcheck(c)
	if c:IsFacedown() then return nil end
	if c:IsType(TYPE_LINK) then return c:GetLink() end
	if c:IsType(TYPE_XYZ) then return c:GetRank() end
	if c:IsLevelAbove(0) then return c:GetLevel() end
	return nil
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
			local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			if #mg==0 then return end
			
			local min_val=nil
			local valid_group=Group.CreateGroup()
			
			for tc in aux.Next(mg) do
				local val = s.valcheck(tc)
				if val then
					if not min_val or val < min_val then
						min_val = val
						valid_group:Clear()
						valid_group:AddCard(tc)
					elseif val == min_val then
						valid_group:AddCard(tc)
					end
				end
			end
			
			if #valid_group>0 then
				Duel.BreakEffect()
				Duel.Destroy(valid_group,REASON_EFFECT)
			end
		end
	end
end
