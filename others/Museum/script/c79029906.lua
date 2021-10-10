--普罗旺斯·生命之地收藏-荒原行者
function c79029906.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),11,3)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c79029906.tgtg)
	e1:SetOperation(c79029906.tgop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029906)
	e2:SetTarget(c79029906.tgtg1)
	e2:SetOperation(c79029906.tgop1)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c79029906.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c79029906.tgop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Debug.Message("状态绝佳！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029906,0))
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function c79029906.tgcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029906.tgfil1(c)
	return c:GetAttack()~=c:GetBaseAttack() 
end
function c79029906.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029906.tgfil1,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c79029906.tgop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Debug.Message("已经警告过了哦！灾害处理，现在开始！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029906,1))
	local g=Duel.GetMatchingGroup(c79029906.tgfil1,tp,0,LOCATION_MZONE,1,nil)
	if g:GetCount()>0 then 
	Duel.SendtoGrave(g,REASON_RULE)
	end
end






