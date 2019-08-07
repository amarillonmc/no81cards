--界限龙王 卡奥斯
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103009
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND+LOCATION_GRAVE,cm.spcon,cm.spop)
	local e2=rsef.SV_UPDATE(c,"atk",1000,cm.atkcon)
	local e3=rsef.SV_IMMUNE_EFFECT(c,cm.val,cm.atkcon)
	local e4=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},nil,nil,LOCATION_MZONE,cm.cecon,nil,cm.cetg,cm.ceop)
end
function cm.cecon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil,REASON_EFFECT) end
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)~=0 then
		local rg=Duel.SelectReleaseGroup(1-tp,nil,1,1,nil)
		if #rg>0 then
			Duel.Release(rg,REASON_EFFECT)
		end
	end
end
function cm.atkcon(e)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.val(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler()~=e:GetHandler()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard,nil,0x337)
	return g:CheckSubGroup(cm.rfilter,2,2,tp)
end
function cm.rfilter(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard,nil,0x337)
	rsof.SelectHint(tp,"res")
	local rg=g:SelectSubGroup(tp,cm.rfilter,false,2,2,tp)
	if rg:IsExists(Card.IsSetCard,2,nil,0x1337) then
		c:RegisterFlagEffect(m,rsreset.est-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	Duel.Release(rg,REASON_EFFECT)
end
