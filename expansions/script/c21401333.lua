--熔岩谷薰风骑士
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--超量召唤：
	--4星「熔岩」或「薰风」怪兽×2
	--也可以使用自己场上表侧的「熔岩」魔法·陷阱卡作为4星怪兽
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.xyzcon)
	e0:SetTarget(s.xyztg)
	e0:SetOperation(s.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--①：将手卡·场上的至少2张卡作为素材，抽3张
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--②：无效发动，取除2个素材，种类不同的场合可以除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,id+2)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--③：场上·墓地的这张卡成为效果对象时检索
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,id+3)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={0x0039,0x0010}
s.listed_names={74845897}

--超量召唤手续

--检查卡片是否受到“不能作为超量素材”的效果
function s.xyzlimitcheck(c,xyzc)
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
	for _,te in ipairs(eset) do
		local val=te:GetValue()
		if type(val)=="function" then
			if val(te,xyzc) then
				return false
			end
		elseif type(val)=="number" then
			if val~=0 then
				return false
			end
		elseif val==true then
			return false
		end
	end
	return true
end

--可以用于超量召唤的素材
function s.xyzfilter(c,xyzc,tp)
	--4星「熔岩」或「薰风」怪兽
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup()
			and c:IsCanBeXyzMaterial(xyzc)
			and c:IsXyzLevel(xyzc,4)
			and (
				c:IsSetCard(0x0039)
				or c:IsSetCard(0x0010)
			)
	end
	--自己场上表侧表示、原本类型为魔法或陷阱的「熔岩」卡
	return c:IsControler(tp)
		and c:IsLocation(LOCATION_SZONE)
		and c:IsFaceup()
		and c:IsSetCard(0x0039)
		and (c:GetType()&(TYPE_SPELL+TYPE_TRAP))~=0
		and c:IsCanOverlay(tp)
		and s.xyzlimitcheck(c,xyzc)
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
	if #g~=2 then return false end
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then
		return false
	end
	--处理要求至少使用一定数量超量素材的效果
	local lg=g:Filter(
		Card.IsHasEffect,
		nil,
		EFFECT_XYZ_MIN_COUNT,
		tp
	)
	local tc=lg:GetFirst()
	while tc do
		local te=tc:IsHasEffect(EFFECT_XYZ_MIN_COUNT,tp)
		if te and #g<te:GetValue() then
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)

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

	--所选素材中存在超量怪兽时，
	--把那些怪兽原本持有的素材送去墓地
	local exg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		exg:Merge(tc:GetOverlayGroup())
		tc=mg:GetNext()
	end
	if #exg>0 then
		Duel.SendtoGrave(exg,REASON_RULE)
	end

	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	if keep then
		mg:DeleteGroup()
	end
end

--①

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

--可以通过①作为素材叠放的卡
function s.ovmatfilter(c,xc,tp)
	if c==xc
		or not c:IsControler(tp)
		or c:IsType(TYPE_TOKEN)
		or c:IsForbidden() then
		return false
	end
	--手卡中的卡不能使用IsCanOverlay检查
	if c:IsLocation(LOCATION_HAND) then
		return s.xyzlimitcheck(c,xc)
	end
	return c:IsOnField()
		and c:IsCanOverlay(tp)
		and s.xyzlimitcheck(c,xc)
end

--用于满足“包含「熔岩」或「薰风」卡”的卡
function s.setmatfilter(c)
	return (
			c:IsLocation(LOCATION_HAND)
			or c:IsFaceup()
		)
		and (
			c:IsSetCard(0x0039)
			or c:IsSetCard(0x0010)
		)
end

function s.getovmatgroup(e,tp)
	local c=e:GetHandler()
	return Duel.GetMatchingGroup(
		s.ovmatfilter,
		tp,
		LOCATION_HAND+LOCATION_ONFIELD,
		0,
		c,
		c,
		tp
	)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=s.getovmatgroup(e,tp)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,3)
			and #mg>=2
			and mg:IsExists(s.setmatfilter,1,nil)
	end
	Duel.SetOperationInfo(
		0,
		CATEGORY_DRAW,
		nil,
		0,
		tp,
		3
	)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not c:IsFaceup()
		or not c:IsType(TYPE_XYZ) then
		return
	end

	local mg=s.getovmatgroup(e,tp)
	local ag=mg:Filter(s.setmatfilter,nil)
	if #mg<2 or #ag==0 then return end

	--先选择1张「熔岩」或「薰风」卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=ag:Select(tp,1,1,nil)

	--再选择至少1张其他卡，可以选择更多
	local rg=mg:Clone()
	rg:Sub(sg)
	if #rg==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=rg:Select(tp,1,#rg,nil)
	sg:Merge(sg2)
	if #sg<2 then return end

	--选择的卡中有超量怪兽时，
	--先将那些怪兽持有的素材送去墓地
	local exg=Group.CreateGroup()
	local tc=sg:GetFirst()
	while tc do
		exg:Merge(tc:GetOverlayGroup())
		tc=sg:GetNext()
	end
	if #exg>0 then
		Duel.SendtoGrave(exg,REASON_RULE)
	end

	Duel.Overlay(c,sg)
	Duel.Draw(tp,3,REASON_EFFECT)
end

--②

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(
			tp,
			2,
			REASON_EFFECT
		)
	end
	Duel.SetOperationInfo(
		0,
		CATEGORY_NEGATE,
		eg,
		1,
		0,
		0
	)
	Duel.SetOperationInfo(
		0,
		CATEGORY_REMOVE,
		re:GetHandler(),
		1,
		0,
		0
	)
end

--取得发动效果的卡的种类
function s.geteffecttype(re)
	if re:IsActiveType(TYPE_MONSTER) then
		return TYPE_MONSTER
	elseif re:IsActiveType(TYPE_SPELL) then
		return TYPE_SPELL
	elseif re:IsActiveType(TYPE_TRAP) then
		return TYPE_TRAP
	end
	return 0
end

--检查素材的原本种类是否与发动效果的卡相同
function s.sametypefilter(c,ctype)
	return (c:GetOriginalType()&ctype)~=0
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ctype=s.geteffecttype(re)

	if not Duel.NegateActivation(ev) then return end

	local og=c:GetOverlayGroup()
	if #og<2 then return end

	--直接选择并送墓2个素材，
	--从而记录实际取除的是哪2张卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=og:Select(tp,2,2,nil)
	if #sg<2 then return end

	--两张素材都必须与发动效果的卡种类不同
	local diff=ctype~=0
		and not sg:IsExists(
			s.sametypefilter,
			1,
			nil,
			ctype
		)

	if Duel.SendtoGrave(sg,REASON_EFFECT)~=2 then
		return
	end

	if not diff
		or not rc
		or not rc:IsRelateToEffect(re)
		or not rc:IsAbleToRemove() then
		return
	end

	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end

--③

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local g=Duel.GetChainInfo(
		ev,
		CHAININFO_TARGET_CARDS
	)
	return g and g:IsContains(e:GetHandler())
end

function s.thfilter(c)
	return c:IsAbleToHand()
		and (
			(
				c:IsSetCard(0x0010)
				and (
					c:IsType(TYPE_SPELL)
					or c:IsType(TYPE_TRAP)
				)
			)
			or c:IsCode(74845897)
		)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--强制发动，即使卡组中没有对应卡也会建立连锁
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

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(
		tp,
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		1,
		1,
		nil
	)
	if #g>0
		and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
