--熔岩谷侵入魔鬼
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--超量召唤：4星「熔岩」或「入魔」怪兽×2
	--也可以使用自己场上表侧的「熔岩」魔法·陷阱卡作为4星怪兽
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(
		EFFECT_FLAG_CANNOT_DISABLE
		+EFFECT_FLAG_UNCOPYABLE
	)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.xyzcon)
	e0:SetTarget(s.xyztg)
	e0:SetOperation(s.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--①：取除最多2个素材，检索相同数量
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--②：从墓地成为自己场上超量怪兽的素材
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+2)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
	--③：场上·墓地的这张卡成为效果对象时检索
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e3:SetCountLimit(1,id+3)
	e3:SetCondition(s.th3con)
	e3:SetTarget(s.th3tg)
	e3:SetOperation(s.th3op)
	c:RegisterEffect(e3)
end
s.listed_series={0x0039,0x000a,0x0065}
s.listed_names={74845897}

--超量召唤手续

--检查表侧魔法·陷阱是否可以成为超量素材
function s.stcanxyz(c,xyzc,tp)
	if not c:IsCanOverlay(tp) or c:IsForbidden() then
		return false
	end
	--检查“不能作为超量素材”的效果
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
	for _,te in ipairs(eset) do
		local val=te:GetValue()
		if type(val)=="function" then
			if val(te,xyzc) then
				return false
			end
		elseif type(val)=="number" and val~=0 then
			return false
		elseif val==true then
			return false
		end
	end
	return true
end

--可以用于这张卡超量召唤的卡
function s.xyzfilter(c,xyzc,tp)
	--4星「熔岩」或「入魔」怪兽
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup()
			and c:IsCanBeXyzMaterial(xyzc)
			and c:IsXyzLevel(xyzc,4)
			and (
				c:IsSetCard(0x0039)
				or c:IsSetCard(0x000a)
			)
	end
	--自己场上表侧的「熔岩」魔法·陷阱卡
	--使用原本类型判断，避免装备状态的怪兽被误判
	return c:IsControler(tp)
		and c:IsLocation(LOCATION_SZONE)
		and c:IsFaceup()
		and c:IsSetCard(0x0039)
		and (
			c:GetType()
			&(TYPE_SPELL+TYPE_TRAP)
		)~=0
		and s.stcanxyz(c,xyzc,tp)
end

function s.getxyzgroup(tp,xyzc,og)
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(
			tp,
			LOCATION_MZONE+LOCATION_SZONE,
			0
		)
	end
	return mg:Filter(s.xyzfilter,nil,xyzc,tp)
end

function s.xyzgoal(g,tp,xyzc)
	if g:GetCount()~=2 then return false end
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then
		return false
	end
	--处理要求至少使用一定数量素材的效果
	local lg=g:Filter(
		Card.IsHasEffect,
		nil,
		EFFECT_XYZ_MIN_COUNT,
		tp
	)
	local tc=lg:GetFirst()
	while tc do
		local te=tc:IsHasEffect(
			EFFECT_XYZ_MIN_COUNT,
			tp
		)
		if te and g:GetCount()<te:GetValue() then
			return false
		end
		tc=lg:GetNext()
	end
	return true
end

function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
		return false
	end
	local tp=c:GetControler()
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if minc>maxc then return false end

	local mg=s.getxyzgroup(tp,c,og)
	local mustg=Duel.GetMustMaterial(
		tp,
		EFFECT_MUST_BE_XMATERIAL
	)
	if mustg:IsExists(
		Auxiliary.MustMaterialCounterFilter,
		1,
		nil,
		mg
	) then
		return false
	end

	Duel.SetSelectedCard(mustg)
	Auxiliary.GCheckAdditional=
		Auxiliary.TuneMagicianCheckAdditionalXyz
	local res=mg:CheckSubGroup(
		s.xyzgoal,
		minc,
		maxc,
		tp,
		c
	)
	Auxiliary.GCheckAdditional=nil
	return res
end

function s.xyztg(
	e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max
)
	if og and not min then
		return true
	end
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if minc>maxc then return false end

	local mg=s.getxyzgroup(tp,c,og)
	local mustg=Duel.GetMustMaterial(
		tp,
		EFFECT_MUST_BE_XMATERIAL
	)
	Duel.SetSelectedCard(mustg)
	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_XMATERIAL
	)

	local cancel=Duel.IsSummonCancelable()
	Auxiliary.GCheckAdditional=
		Auxiliary.TuneMagicianCheckAdditionalXyz
	local g=mg:SelectSubGroup(
		tp,
		s.xyzgoal,
		cancel,
		minc,
		maxc,
		tp,
		c
	)
	Auxiliary.GCheckAdditional=nil

	if not g then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end

function s.xyzop(
	e,tp,eg,ep,ev,re,r,rp,c,og,min,max
)
	local mg
	local keep=false
	if og and not min then
		mg=og
	else
		mg=e:GetLabelObject()
		keep=true
	end
	if not mg then return end

	--所选素材中有超量怪兽时，
	--将那些超量怪兽原本持有的素材送去墓地
	local ogroup=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local g=tc:GetOverlayGroup()
		if g:GetCount()>0 then
			ogroup:Merge(g)
		end
		tc=mg:GetNext()
	end
	if ogroup:GetCount()>0 then
		Duel.SendtoGrave(ogroup,REASON_RULE)
	end

	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	if keep then
		mg:DeleteGroup()
	end
end

--①

function s.thfilter(c)
	return (
			c:IsSetCard(0x0039)
			or c:IsSetCard(0x0065)
		)
		and (
			c:IsType(TYPE_SPELL)
			or c:IsType(TYPE_TRAP)
		)
		and c:IsAbleToHand()
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local deckct=Duel.GetMatchingGroupCount(
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		nil
	)
	if chk==0 then
		return deckct>0
			and c:CheckRemoveOverlayCard(
				tp,
				1,
				REASON_COST
			)
	end

	local maxct=1
	if deckct>=2
		and c:CheckRemoveOverlayCard(
			tp,
			2,
			REASON_COST
		) then
		maxct=2
	end

	local ct=1
	if maxct==2 then
		ct=Duel.AnnounceNumber(tp,1,2)
	end
	c:RemoveOverlayCard(
		tp,
		ct,
		ct,
		REASON_COST
	)
	e:SetLabel(ct)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then
		return Duel.GetMatchingGroupCount(
			s.thfilter,
			tp,
			LOCATION_DECK,
			0,
			nil
		)>=ct
	end
	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		nil,
		ct,
		tp,
		LOCATION_DECK
	)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		nil
	)
	--必须加入与取除数量相同的卡
	if g:GetCount()<ct then return end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_ATOHAND
	)
	local sg=g:Select(tp,ct,ct,nil)
	if sg:GetCount()>0
		and Duel.SendtoHand(
			sg,
			nil,
			REASON_EFFECT
		)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end

--②

function s.ovfilter(c)
	return c:IsFaceup()
		and c:IsType(TYPE_XYZ)
end

function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_MZONE)
			and s.ovfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(
			s.ovfilter,
			tp,
			LOCATION_MZONE,
			0,
			1,
			nil
		)
	end
	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TARGET
	)
	Duel.SelectTarget(
		tp,
		s.ovfilter,
		tp,
		LOCATION_MZONE,
		0,
		1,
		1,
		nil
	)
	Duel.SetOperationInfo(
		0,
		CATEGORY_LEAVE_GRAVE,
		e:GetHandler(),
		1,
		tp,
		LOCATION_GRAVE
	)
end

function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc
		or not tc:IsRelateToEffect(e)
		or not tc:IsFaceup()
		or not tc:IsType(TYPE_XYZ)
		or not c:IsRelateToEffect(e)
		or aux.NecroValleyNegateCheck(c) then
		return
	end
	Duel.Overlay(tc,c)
end

--③

function s.th3con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(
		EFFECT_FLAG_CARD_TARGET
	) then
		return false
	end
	local g=Duel.GetChainInfo(
		ev,
		CHAININFO_TARGET_CARDS
	)
	return g and g:IsContains(e:GetHandler())
end

function s.th3filter(c)
	return c:IsAbleToHand()
		and (
			(
				c:IsSetCard(0x0065)
				and (
					c:IsType(TYPE_SPELL)
					or c:IsType(TYPE_TRAP)
				)
			)
			or c:IsCode(74845897)
		)
end

function s.th3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	--强制发动，即使卡组中没有可加入的卡也会建立连锁
	if chk==0 then return true end
	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		nil,
		1,
		tp,
		LOCATION_DECK
	)
end

function s.th3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_ATOHAND
	)
	local g=Duel.SelectMatchingCard(
		tp,
		s.th3filter,
		tp,
		LOCATION_DECK,
		0,
		1,
		1,
		nil
	)
	if g:GetCount()>0
		and Duel.SendtoHand(
			g,
			nil,
			REASON_EFFECT
		)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
