--反转世界★格莱伍德
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006023,"FanZhuanShiJie")
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,nil,"sp,se,th",nil,nil,nil,rsop.target({cm.spfilter,"sp",LOCATION_HAND },{cm.thfilter,"th",LOCATION_DECK }),cm.act)
	local e2 = rsef.I(c,"ms",1,"ms,ctrl","tg",LOCATION_FZONE,nil,nil,rstg.target(cm.mvfilter,"ms",LOCATION_MZONE,LOCATION_MZONE),cm.mvop)
end
function cm.mvfilter(c,e,tp)
	return c:IsControlerCanBeChanged() or Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
end
function cm.mvop(e,tp)
	local tc = rscf.GetTargetCard()
	if not tc then return end
	local b1 = tc:IsControlerCanBeChanged()
	local b2 = Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
	if not b1 and not b2 then return end
	if not b1 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=0
		if tc:IsControler(tp) then
		   s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		else
		   s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)/0x10000
		end
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	else
		Duel.GetControl(tc,1-tc:GetControler(),0)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp) > 0 and rsfz.IsSet(c)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsfz.IsSetM(c)
end
function cm.act(e,tp)
	if rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,{0,tp,1-tp,false,false,POS_FACEUP },e,tp) > 0 then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end